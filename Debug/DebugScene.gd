extends Node2D

@onready var player = $Character
@onready var camera = $Camera2D
@onready var boss = $Enemy

func _ready():
	GameManager.player = player
	GameManager.camera = camera
	
	print(GameManager.get_screen_box())

func _process(_delta : float):
	if Input.is_action_just_pressed("z"):
		boss.start()
	if Input.is_action_just_pressed("x"):
		OS.shell_open("https://godotengine.org")
