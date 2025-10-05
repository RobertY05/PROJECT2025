extends Attack

@export var laser_scene : PackedScene
@export var sweep_duration := 1.5      # time to sweep from top-right to top-left
@export var charge_time := 1.5          # charging duration
@export var max_scale := Vector2(0.1, 0.1)  # max scale for glow

@onready var charge_glow = $ChargeGlow
@onready var charge_timer = $ChargeTimer
@onready var charge_sound = $ChargeSound
@onready var shoot_sound = $ShootSound

func _ready():
	# Start charging
	charge_timer.wait_time = charge_time
	charge_timer.start()
	charge_sound.play()

	# Animate charge glow while charging
	while charge_timer.time_left > 0:
		var percent = 1 - charge_timer.time_left / charge_timer.wait_time
		var smooth = 1 - pow(1 - percent, 3)
		charge_glow.scale = smooth * max_scale
		charge_glow.global_position = boss_ref.eye_r_shoot_point.global_position
		charge_glow.modulate.a = 0.6
		await get_tree().process_frame

	# Fire laser after charging
	await fire()
	finished()
	queue_free()

func cubicSpeed(t: float) -> float:
	return t * t * t
	
func fire():
	# Hide charge effects and play shoot sound
	charge_glow.hide()
	charge_sound.stop()
	shoot_sound.play()

	# Instantiate the laser
	var laser = laser_scene.instantiate() as Area2D
	boss_ref.get_parent().add_child(laser)
	laser.global_position = boss_ref.eye_r_shoot_point.global_position

	# Make sure it draws above everything
	laser.z_index = 100
	laser.z_as_relative = false

	# Sweep rotation from 0 to -PI over sweep_duration
	var elapsed = 0.0
	var start_angle = -PI
	var end_angle = 0.0
	
	while elapsed < sweep_duration:
		if not is_instance_valid(laser):
			break
		var t = elapsed / sweep_duration
		var cubed = cubicSpeed(t)
		laser.global_rotation = lerp(start_angle, end_angle, cubed)
		elapsed += get_process_delta_time()
		await get_tree().process_frame

	# Ensure final rotation
	if is_instance_valid(laser):
		laser.global_rotation = end_angle
