extends Area2D

@export var damage := 30.0
@export var knockback := 15.0
@export var active_duration := 2

@onready var collision_shape = $CollisionShape2D
@onready var beam_sprite = $Sprite2D

func _ready():
	beam_sprite.visible = true
	beam_sprite.scale = Vector2(1, 1) 
	collision_shape.disabled = false
	
	await get_tree().create_timer(active_duration).timeout
	queue_free()

func _on_body_entered(body):
	if body is Actor and body.friendly:
		var dir = (body.global_position - global_position).normalized()
		body.hurt(damage, dir * knockback)
