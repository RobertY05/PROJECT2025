extends Attack

@export var missile_scene : PackedScene
@export var shots = 4

@onready var launch_sound = $LaunchSound

@export var lockon_delay = 1
@export var shoot_delay = 0.15

var missile_list = []
var initial_rotation = 180
var current_rotation : float
var rotation_step = 15

func _ready():
	current_rotation = initial_rotation
	for i in range(shots):
		var new_missile = missile_scene.instantiate()
		missile_list.append(new_missile)
		new_missile.global_position = global_position
		new_missile.rotation = deg_to_rad(current_rotation)
		current_rotation += rotation_step
		get_tree().get_root().add_child(new_missile)
		launch_sound.play()
		await get_tree().create_timer(shoot_delay).timeout
	
	await get_tree().create_timer(lockon_delay).timeout
	
	for missile in missile_list:
		if is_instance_valid(missile):
			missile.dumb = false
	
	await get_tree().create_timer(shoot_delay).timeout
	
	current_rotation = initial_rotation + 180
	rotation_step *= -1
	
	for i in range(shots):
		var new_missile = missile_scene.instantiate()
		missile_list.append(new_missile)
		new_missile.global_position = global_position
		new_missile.rotation = deg_to_rad(current_rotation)
		current_rotation += rotation_step
		get_tree().get_root().add_child(new_missile)
		launch_sound.play()
		await get_tree().create_timer(shoot_delay).timeout
	
	await get_tree().create_timer(lockon_delay).timeout
	
	for missile in missile_list:
		if is_instance_valid(missile):
			missile.dumb = false
	
	finished()
	
	while launch_sound.playing:
		await get_tree().process_frame
