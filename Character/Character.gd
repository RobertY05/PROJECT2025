extends Actor

@export var speed := 300.0
@export var dash_speed := 4000.0
@export var dash_time := 1.5
@export var dash_invulnerability_time = 0.3

@export var dash_ghost : PackedScene

@onready var dash_timer = $DashTimer
@onready var dash_invulnerability_timer = $DashInvulnerabilityTimer
@onready var dash_ghost_timer = $DashGhostTimer
@onready var move_bounce_timer = $MoveBounceTimer

@onready var character_sprite = $CharacterSprite

var original_scale : Vector2
var move_bounce_percent = 0.8
var lerp_percent = 0.2
var moving = false

func _ready():
	health = 100.0
	friendly = true
	
	dash_timer.wait_time = dash_time
	dash_invulnerability_timer.wait_time = dash_invulnerability_time
	original_scale = character_sprite.scale

func _physics_process(_delta : float):
	var acceleration = Vector2.ZERO
	character_sprite.scale = lerp(character_sprite.scale, original_scale, lerp_percent)
	
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
