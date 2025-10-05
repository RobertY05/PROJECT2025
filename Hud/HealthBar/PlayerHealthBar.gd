extends Node2D

@onready var bar = $TextureProgressBar

func _ready():
	bar.max_value = GameManager.player_max_health
	bar.min_value = 0

func _process(_delta):
	bar.value = GameManager.player.health
