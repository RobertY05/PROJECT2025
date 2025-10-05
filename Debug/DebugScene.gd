extends Node2D

@onready var player = $Character
@onready var camera = $Camera2D
@onready var boss = $Enemy

func _ready():
	GameManager.player = player
	GameManager.camera = camera
	GameManager.boss = boss
	
	print(GameManager.get_screen_box())

func _process(_delta : float):
	if Input.is_action_just_pressed("z"):
		boss.start()
	if Input.is_action_just_pressed("x"):
		boss.shoot_chain_gun_l()
	if Input.is_action_just_pressed("c"):
		boss.radar.look_at(GameManager.player.global_position)
