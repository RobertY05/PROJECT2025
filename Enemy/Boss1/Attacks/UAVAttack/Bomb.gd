extends Area2D

@onready var crosshair = $Crosshair

@onready var shape = $Box.shape.get_rect()
@onready var clouds = [$Cloud1, $Cloud2]
@onready var explosion = $Explosion

@onready var poison_tick_timer = $GasCloud/PoisonTickTimer
@onready var poison_fade_timer = $GasCloud/PoisonFadeTimer
@onready var cloud_idle_timer = $GasCloud/CloudIdleTimer
@onready var gas_cloud = $GasCloud

@onready var explosion_sound = $ExplosionSound
@onready var explosion_linger_timer = $ExplosionLingerTimer
@onready var explosion_shape = $ExplosionShape

@export var damage := 20
@export var poison := 8
@export var knockback := 4000

var things_to_poison = []

var velocity : Vector2
var speed := 10

var explosion_fade_speed = 0.05

var max_explode_delay = 1.2

var dead = false

var chosen_cloud = null
var original_cloud_scale : Vector2
var original_cloud_position : Vector2
var cloud_lerp_speed = 0.1
var cloud_max_offset = 15

func _ready():
	chosen_cloud = clouds.pick_random()
	original_cloud_scale = chosen_cloud.scale
	original_cloud_position = chosen_cloud.position

func lockon():
	crosshair.modulate.g = 0
	crosshair.modulate.b = 0
	velocity = Vector2.ZERO

func explode():
	await get_tree().create_timer(randf_range(0, max_explode_delay)).timeout
	crosshair.hide()
	explosion.show()
	explosion.modulate.a = 1
	explosion_sound.play()
	explosion_linger_timer.start()
	explosion_shape.force_shapecast_update()
	for i in range(explosion_shape.get_collision_count()):
		if explosion_shape.get_collider(i) is Actor and explosion_shape.get_collider(i).friendly:
			var actor : Actor = explosion_shape.get_collider(i)
			actor.hurt(damage, (actor.global_position - global_position).normalized() * knockback)
	
	poison_fade_timer.start()
	poison_tick_timer.start()
	
	chosen_cloud.show()
	chosen_cloud.modulate.a = 0
	chosen_cloud.scale = Vector2.ZERO

func _physics_process(_delta):
	global_position += velocity
	var bounds = GameManager.camera.get_viewport_rect()
	if global_position.y - shape.size.y / 2 < bounds.position.y - bounds.size.y / 2:
		velocity.y = abs(velocity.y)
	if global_position.y + shape.size.y / 2 > bounds.position.y + bounds.size.y / 2:
		velocity.y = -abs(velocity.y)
	if global_position.x - shape.size.x / 2 < bounds.position.x - bounds.size.x / 2:
		velocity.x = abs(velocity.x)
	if global_position.x + shape.size.x / 2 > bounds.position.x + bounds.size.x / 2:
		velocity.x = -abs(velocity.x)
	
	if explosion_linger_timer.is_stopped():
		explosion.modulate.a = max(0, explosion.modulate.a - explosion_fade_speed)
	if poison_fade_timer.is_stopped():
		chosen_cloud.modulate.a = max(0, chosen_cloud.modulate.a - explosion_fade_speed)
	else:
		chosen_cloud.modulate.a = min(1, chosen_cloud.modulate.a + explosion_fade_speed / 5)
		chosen_cloud.scale = lerp(chosen_cloud.scale, original_cloud_scale, cloud_lerp_speed)
	
	var idle_percent = abs((cloud_idle_timer.wait_time / 2 - cloud_idle_timer.time_left) / (cloud_idle_timer.wait_time / 2))
	var idle_smooth = 0.5 - 0.5 * cos(idle_percent * PI)
	chosen_cloud.position.y = original_cloud_position.y + cloud_max_offset * idle_smooth
	
	if dead:
		var should_kill = true
		if chosen_cloud.modulate.a > 0.01:
			should_kill = false
		if should_kill:
			queue_free()



func end_cloud():
	poison_tick_timer.stop()
	dead = true


func _on_gas_cloud_body_entered(body):
	if body is Actor and body.friendly:
		things_to_poison.append(body)

func _on_gas_cloud_body_exited(body):
	if body in things_to_poison:
		things_to_poison.erase(body)

func do_poison():
	for actor in things_to_poison:
		actor.apply_poison(poison)
