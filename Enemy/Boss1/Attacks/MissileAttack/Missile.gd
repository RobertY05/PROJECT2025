extends Actor

@export var speed := 150
@export var max_rotation := 3
@export var detonate_distance := 80

@onready var missile_sprite = $MissileSprite
@onready var explosion_shape = $ExplosionShape
@onready var explosion_sprite = $ExplosionSprite
@onready var explosion_sound = $ExplosionSound
@onready var explosion_linger_timer = $ExplosionLingerTimer

@export var damage := 20
@export var knockback := 4000

var dumb = true
var dead = false
var explosion_fade_speed = 0.05

func _ready():
	health = 5

func hurt(amount : float, _force : Vector2 = Vector2.ZERO) -> void:
	super(amount)

func _physics_process(_delta : float):
	if not dead:
		if not dumb:
			var desired_angle = global_position.angle_to_point(GameManager.player.global_position)
			var diff = wrapf(desired_angle - rotation, -PI, PI)
			var angle_step = clamp(diff, -deg_to_rad(max_rotation), deg_to_rad(max_rotation))
			rotation += angle_step
		
		var acceleration = Vector2(cos(rotation), sin(rotation)).normalized() * speed
		velocity += acceleration
		
		if global_position.distance_to(GameManager.player.global_position) < detonate_distance:
			die()
	elif explosion_linger_timer.is_stopped():
		explosion_sprite.modulate.a = max(0, explosion_sprite.modulate.a - explosion_fade_speed)
		if explosion_sprite.modulate.a < 0.01 and not explosion_sound.playing:
			queue_free()
	
	super(_delta)

func die():
	if dead:
		return
	
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)
	missile_sprite.hide()
	explosion_sprite.show()
	explosion_shape.force_shapecast_update()
	explosion_sound.play()
	explosion_linger_timer.start()
	dead = true
	for i in range(explosion_shape.get_collision_count()):
		if explosion_shape.get_collider(i) is Actor and explosion_shape.get_collider(i).friendly:
			var actor : Actor = explosion_shape.get_collider(i)
			actor.hurt(damage, (actor.global_position - global_position).normalized() * knockback)
