extends Attack

@export var laser_scene : PackedScene
@export var charge_time := 2.5  
@export var firing_time := 2       
@export var max_scale := Vector2(0.25, 0.25)
@export var satellite_offset := Vector2(10, 5)   
@export var warning_length := 2000                   
@export var warning_thickness := 10                  
@export var warning_color := Color(1, 0, 0, 0.5)     
@export var blink_speed := 9.0                      

@onready var charge_glow = $ChargeGlow
@onready var charge_timer = $ChargeTimer
@onready var charge_sound = $ChargeSound
@onready var shoot_sound = $ShootSound

@onready var satellite_shoot_point = boss_ref.satellite_shoot_point
var satellite_original_position : Vector2

var warning_strip : Line2D
var blink_timer := 0.0

func _ready():
	
	# Store original satellite position for knowing where its supposed to sit
	satellite_original_position = satellite_shoot_point.get_parent().position

	# Create warning strip 
	warning_strip = Line2D.new()
	warning_strip.width = warning_thickness
	warning_strip.default_color = warning_color
	warning_strip.points = [Vector2.ZERO, Vector2(warning_length, 0)]
	warning_strip.visible = true
	get_tree().get_root().add_child(warning_strip)  

	# Start charging
	charge_timer.wait_time = charge_time
	charge_timer.start()
	charge_sound.play()

	# Animate charge glow, move/rotate dish, and blinking warning strip
	while charge_timer.time_left > 0:
		var percent = 1 - charge_timer.time_left / charge_timer.wait_time
		var smooth = 1 - pow(1 - percent, 3)

		# Scale and position glow
		charge_glow.scale = smooth * max_scale
		charge_glow.global_position = satellite_shoot_point.global_position
		charge_glow.modulate.a = 0.8

		# Aim at player for percentage of charge, here is 80%
		if percent < 0.8:
			radar_look_at(GameManager.player.global_position)

		# Update warning strip to follow satellite shoot point
		warning_strip.global_position = satellite_shoot_point.global_position
		warning_strip.global_rotation = satellite_shoot_point.get_parent().global_rotation

		# Make the warning strip blink
		blink_timer += get_process_delta_time() * blink_speed
		warning_strip.visible = int(blink_timer) % 2 == 0

		await get_tree().process_frame


	# Fire the big laser
	await fire()

	finished()
	queue_free()


# Rotate the satellite dish (parent of shoot point) to face a world position
func radar_look_at(point: Vector2):
	var dish = satellite_shoot_point.get_parent()
	if not is_instance_valid(dish):
		return
	var dir = (point - satellite_shoot_point.global_position).normalized()
	dish.global_rotation = dir.angle()


func fire():
	# Remove warning strip
	warning_strip.queue_free()
	
	# Hide charge effects, stop charge sound, play shoot sound
	charge_glow.hide()
	charge_sound.stop()
	shoot_sound.play()


	# Instantiate the laser
	var laser = laser_scene.instantiate() as Area2D
	boss_ref.get_parent().add_child(laser)
	laser.global_position = satellite_shoot_point.global_position

	# Make sure laser draws above everything
	laser.z_index = 100
	laser.z_as_relative = false

	# Laser rotation fixed — facing last dish rotation
	laser.global_rotation = satellite_shoot_point.get_parent().global_rotation
	await get_tree().create_timer(firing_time).timeout
