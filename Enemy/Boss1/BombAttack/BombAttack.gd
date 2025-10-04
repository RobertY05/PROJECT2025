extends Attack

#Editable variables and stuff
@export var Labubu : PackedScene
@export var bombs = 6
@export var waves = 3
@export var fire_cooldown = 2.25

#The timer node
@onready var timer = $Timer


func _ready():
	#Wait till all waves are done then run the next attack and delete all bombs
	await Waves()
	finished()
	queue_free()
	
func Waves():
	for w in range(waves):
		#Swawns all bombs then waits for the cooldown
		SpawnAllBombs()
		await get_tree().create_timer(fire_cooldown).timeout
		
func SpawnAllBombs():
	for i in range(bombs):
		var bomb = Labubu.instantiate()
		bomb.global_position = get_random_screen_position()
		get_tree().get_root().add_child(bomb)


func get_random_screen_position() -> Vector2:
	#Find active camera and get its size
	var cam = get_viewport().get_camera_2d()  
	var screen_size = get_viewport_rect().size
	
	# top-left corner of the visible area
	var top_left = cam.global_position - screen_size / 2
	
	# choose a random position within the visible screen rectangle
	var x = randf() * screen_size.x + top_left.x
	var y = randf() * screen_size.y + top_left.y
	
	return Vector2(x, y)
