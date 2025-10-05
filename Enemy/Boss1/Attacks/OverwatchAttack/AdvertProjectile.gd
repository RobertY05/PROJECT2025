extends Area2D

@onready var shape = $Box.shape.get_rect()

var velocity : Vector2
var speed := 5

func _on_body_entered(body):
	if body is Actor and body.friendly:
		OS.shell_open("https://overwatch.blizzard.com/en-us/")
		queue_free()

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

func done():
	queue_free()
