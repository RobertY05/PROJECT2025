extends Node2D

@onready var lights : Array[Sprite2D] = [$Glow1, $Glow2, $Glow3, $Glow4, $Glow5]

@onready var message_on_timer = $MessageOnTimer
@onready var message_off_timer = $MessageOffTimer

@onready var label = $Label
@onready var geiger_sound = $GeigerSound
@onready var alarm_sound = $AlarmSound

@onready var flash_timer = $FlashTimer
@onready var flash = $Flash

var message = "SUPER MEGA ULTRA CANCER DETECTED PLEASE SEE MANUAL 5G TOWER IN RADIUS MEGA AIDS LIGMA CANCER DETECTED IN LOWER THYROID GLAND 5G APPLY SEED OIL TALLOW cia.gov/US/5g/conspiracy SEEK SHELTER IMMEDIATELY DANGER DANGER DANGER 5G YOUR AREA DO NOT PANIC LETHAL DOSES COVID 5G VACCINE DETECTED TAKE FIVE TABLETS PARACETENOMYACETYLINEONL PLEASE CONSULT DOCTOR FOR SIDE EFFECTS"
var message_idx = 0

var jitter = 0.5

var desired_rot = -90
var down_rot = -90
var up_rot = 0
var lerp_percent = 0.1

func _ready():
	message = message.split(" ")
	rotation = deg_to_rad(down_rot)

func _physics_process(_delta):
	var percent = GameManager.player.poison / GameManager.player.max_poison
	for light in lights:
		light.modulate.a = 0
	
	geiger_sound.volume_linear = 0
	
	var flash_percent = flash_timer.time_left / flash_timer.wait_time
	flash.modulate.a = flash_percent
	
	if percent > 0.01:
		desired_rot = up_rot
		lights[0].modulate.a = 1
		geiger_sound.volume_linear = 0.4
	else:
		desired_rot = down_rot
	if percent > 0.2:
		lights[1].modulate.a = 1
		geiger_sound.volume_linear = 0.6
	if percent > 0.4:
		lights[2].modulate.a = 1
		geiger_sound.volume_linear = 0.8
	if percent > 0.6:
		lights[3].modulate.a = 1
		geiger_sound.volume_linear = 1.0
	else:
		alarm_sound.stop()
		flash_timer.stop()
	if percent > 0.8:
		lights[4].modulate.a = 1
		geiger_sound.volume_linear = 1.2
		if not alarm_sound.playing:
			alarm_sound.play()
			flash_timer.start()
	
	for light in lights:
		if light.modulate.a > 0.01:
			light.modulate.a += randf_range(-jitter, jitter)
	
	rotation = lerp(rotation, deg_to_rad(desired_rot), lerp_percent)

func hide_message():
	label.text = ""
	message_idx += 1
	if message_idx >= message.size():
		message_idx = 0
	message_on_timer.start()

func show_message():
	label.text = message[message_idx]
	message_off_timer.start()
