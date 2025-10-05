extends Actor

@export var max_health = 100.0

@export var speed := 200.0
@export var dash_speed := 3000.0

@export var max_poison := 130.0
@export var poison_threshold := 100
@export var poison_clear_per_tick := 3
@export var poison_damage_per_tick := 5

@export var dash_ghost : PackedScene
@export var death_explosion : PackedScene

@onready var dash_timer = $DashTimer
@onready var dash_invulnerability_timer = $DashInvulnerabilityTimer
@onready var dash_ghost_timer = $DashGhostTimer
@onready var move_bounce_timer = $MoveBounceTimer
@onready var invulnerability_timer = $InvulnerabilityTimer

@onready var character_sprite = $CharacterSprite
@onready var hurt_sprite = $UncannyCharacter

@onready var hurt_sound = $HurtSound
@onready var poison_sound = $PoisonSound
@onready var death_sound = $DeathSound
@onready var revive_sound = $ReviveSound

var hurt_fade_speed = 0.01

var original_scale : Vector2
var move_bounce_percent = 0.8
var lerp_percent = 0.2
var moving = false
var poison = 0.0
var dead = false

func _ready():
	health = max_health
	friendly = true
	original_scale = character_sprite.scale

func _physics_process(_delta : float):
	if dead:
		poison = 0
		return
	
	var acceleration = Vector2.ZERO
	character_sprite.scale = lerp(character_sprite.scale, original_scale, lerp_percent)
	hurt_sprite.modulate.a = max(0, hurt_sprite.modulate.a - hurt_fade_speed)
	
	var move_this_frame = false
	if Input.is_action_pressed("move_up"):
		move_this_frame = true
		acceleration.y -= 1
	if Input.is_action_pressed("move_down"):
		move_this_frame = true
		acceleration.y += 1
	if Input.is_action_pressed("move_left"):
		move_this_frame = true
		acceleration.x -= 1
	if Input.is_action_pressed("move_right"):
		move_this_frame = true
		acceleration.x += 1
	
	acceleration = acceleration.normalized()
	
	if Input.is_action_just_pressed("dash") and dash_timer.is_stopped():
		velocity += acceleration * dash_speed
		set_collision_layer_value(1, false)
		dash_invulnerability_timer.start()
		dash_ghost_timer.start()
		dash_timer.start()
	
	acceleration *= speed
	
	velocity += acceleration
	
	if move_this_frame and not moving:
		bounce()
		move_bounce_timer.start()
	elif not moving:
		move_bounce_timer.stop()
		
	moving = move_this_frame
	
	super(_delta)

func hurt(amount : float, force : Vector2 = Vector2.ZERO) -> void:
	velocity += force
	health -= amount
	hurt_sprite.modulate.a = 1.0
	invulnerability_timer.start()
	set_collision_layer_value(1, false)
	hurt_sound.play()
	if health <= 0:
		die()

func die():
	dead = true
	var explosion = death_explosion.instantiate()
	explosion.global_position = global_position
	hide()
	get_tree().get_root().add_child(explosion)
	set_collision_layer_value(1, false)
	poison = 0
	death_sound.play()
	invulnerability_timer.stop()

func revive():
	dead = false
	health = max_health
	$Gun.magazine = $Gun.magazine_size
	var explosion = death_explosion.instantiate()
	explosion.global_position = global_position
	show()
	get_tree().get_root().add_child(explosion)
	invulnerability_timer.start()
	revive_sound.play()

func end_invulnerability():
	set_collision_layer_value(1, true)

func bounce():
	character_sprite.scale.y = original_scale.y * 0.8
	character_sprite.scale.x = original_scale.x / 0.8
	
func end_dash():
	dash_ghost_timer.stop()
	set_collision_layer_value(1, true)

func make_ghost():
	var new_ghost = dash_ghost.instantiate()
	new_ghost.global_position = global_position
	get_tree().get_root().add_child(new_ghost)

func apply_poison(amount):
	poison = min(poison + amount, max_poison)

func handle_poison():
	if poison > poison_threshold:
		health -= poison_damage_per_tick
		hurt_sprite.modulate.a = 1.0
		poison_sound.play()
		if health <= 0:
			die()
	poison = max(0, poison - poison_clear_per_tick)
