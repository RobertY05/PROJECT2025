extends Node2D

@onready var sparks = [$Spark1, $Spark2]
@onready var timer = $Timer

func _ready():
	for spark in sparks:
		spark.hide()
	sparks.pick_random().show()
	timer.start()

func done():
	queue_free()
