extends Node2D

@export var damage := 10.0
@export var speed := 350
@export var knockback := 10.0
@export var return_delay := 3
@export var deceleration := 0.992
@export var return_speed := 250

var velocity : Vector2
var returning := false
var origin : Vector2
var target : Node2D

func _ready():
	origin = global_position
	if target:
		var dir_to_player = (GameManager.player.global_position - global_position).normalized()
		velocity = dir_to_player * speed
		
	await get_tree().create_timer(return_delay).timeout
	returning = true

func _physics_process(delta: float):
	if returning and target:
		var dir_to_origin = (origin - global_position).normalized()
		velocity = dir_to_origin * return_speed
	else:
		velocity *= deceleration

	global_position += velocity * delta
	rotation += 10 * delta

	if returning and global_position.distance_to(origin) < 20:
		queue_free()

func _on_body_entered(body):
	if body is Actor and body.friendly:
		var dir = (body.global_position - global_position).normalized()
		body.hurt(damage, dir * knockback)
		queue_free()
