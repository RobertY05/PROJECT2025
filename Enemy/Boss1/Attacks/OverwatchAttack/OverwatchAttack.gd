extends Attack

@export var advert : PackedScene

@onready var charge_glow = $ChargeGlow
@onready var charge_timer = $ChargeTimer

@onready var charge_sound = $ChargeSound
@onready var shoot_sound = $ShootSound

var max_luminosity = 2
var max_scale = Vector2(1, 1)

func _ready():
	charge_timer.start()
	charge_sound.play()

func _process(_delta):
	var percent = 1 - charge_timer.time_left / charge_timer.wait_time
	var smooth = 1 - (1 - percent) ** 3
	charge_glow.scale = smooth * max_scale
	charge_glow.global_position = boss_ref.satellite_shoot_point.global_position

func fire():
	charge_glow.hide()
	charge_sound.stop()
	shoot_sound.play()
	var new_ad = advert.instantiate()
	new_ad.global_position = boss_ref.satellite_shoot_point.global_position
	new_ad.velocity = (GameManager.player.global_position - new_ad.global_position).normalized() * new_ad.speed
	get_tree().get_root().add_child(new_ad)
	finished()

func done():
	queue_free()
