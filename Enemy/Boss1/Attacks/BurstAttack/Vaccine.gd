extends Node2D

@export var damage := 1
@export var speed := 10
@export var knockback := 10
@export var poison := 15

var velocity : Vector2

func _physics_process(_delta : float):
	global_position += velocity
	if not GameManager.get_screen_box().has_point(global_position):
		queue_free()

func _on_body_entered(body):
	if body is Actor:
		handle_actor(body)

func handle_actor(actor : Actor):
	if actor.friendly:
		actor.hurt(damage, velocity.normalized() * knockback)
		actor.apply_poison(poison)
		queue_free()
