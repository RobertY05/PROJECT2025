extends Attack

@export var bombs = 6
var bombs_list = []

@export var bomb_scene : PackedScene

@onready var lockon_sound = $LockOnSound
@onready var flyby_sound = $FlybySound
@onready var uav = $UAV
@onready var flyby_timer = $FlybyTimer
@onready var explode_delay = 2.0

var max_spawn_delay = 0.4

var left : Vector2
var right : Vector2

func _ready():
	left = Vector2(GameManager.get_screen_box().position.x - 3000, -800)
	right = Vector2(GameManager.get_screen_box().position.x + GameManager.get_screen_box().size.x + 3000, 800)
	uav.global_position = right
	lockon_sound.play()
	for i in range(bombs):
		await get_tree().create_timer(randf_range(0, max_spawn_delay)).timeout
		var new_bomb = bomb_scene.instantiate()
		var bounds = GameManager.camera.get_viewport_rect()
		new_bomb.global_position.x = randf_range(bounds.position.x - bounds.size.x / 2, bounds.position.x + bounds.size.x / 2)
		new_bomb.global_position.y = randf_range(bounds.position.y - bounds.size.y / 2, bounds.position.y + bounds.size.y / 2)
		new_bomb.velocity = Vector2.RIGHT.rotated(deg_to_rad(randf_range(0, 360))) * new_bomb.speed
		get_tree().get_root().add_child(new_bomb)
		bombs_list.append(new_bomb)

func _process(_delta):
	var flyby_percent = flyby_timer.time_left / flyby_timer.wait_time
	uav.global_position = right * flyby_percent + left * (1 - flyby_percent)

func lockon():
	for bomb in bombs_list:
		bomb.lockon()
	flyby_sound.play()
	flyby_timer.start()
	finished()
	await get_tree().create_timer(explode_delay).timeout
	for bomb in bombs_list:
		bomb.explode()

func done():
	queue_free()
