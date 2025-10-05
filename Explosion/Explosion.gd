extends AnimatedSprite2D

func _ready():
	play()

func done():
	queue_free()
