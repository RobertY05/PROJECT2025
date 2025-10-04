extends Sprite2D

var fade_speed = 0.03

func _ready():
	pass

func _physics_process(_delta : float):
	modulate.a = max(modulate.a - fade_speed, 0)
	if modulate.a <= 0:
		queue_free()
