@abstract class_name Actor
extends CharacterBody2D

@export var health : float
@export var friendly := false
@export var knockback_multiplier := 1.0
@export var friction_multiplier := 0.4

func hurt(amount : float, force : Vector2 = Vector2.ZERO) -> void:
	velocity += force
	health -= amount
	if health <= 0:
		die()

func _physics_process(_delta : float):
	velocity = lerp(velocity, Vector2.ZERO, friction_multiplier)
	move_and_slide()

func die():
	queue_free()
