extends Area2D

@export var damage := 20.0
@export var knockback := 15.0
@export var active_duration := 1.5

@onready var collision_shape = $CollisionShape2D
@onready var beam_sprite = $Sprite2D

func _ready():
	print("=== LASER SPAWNED ===")
	print("Laser global position: ", global_position)
	
	
	# Make the laser more visible for testing
	beam_sprite.visible = true
	beam_sprite.scale = Vector2(0.85, 0.85)  # Make it bigger
	collision_shape.disabled = false
	
	await get_tree().create_timer(active_duration).timeout
	queue_free()

func _on_body_entered(body):
	if body is Actor and body.friendly:
		var dir = (body.global_position - global_position).normalized()
		body.hurt(damage, dir * knockback)
