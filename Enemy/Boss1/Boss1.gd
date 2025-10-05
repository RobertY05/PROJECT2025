extends Boss

@onready var idle_timer = $IdleTimer

@onready var waterloo_ring = $CenterLimb/WaterlooRing
var ring_spin_speed = 0.1

@onready var radar_limb = $RadarLimb
@onready var radar = $RadarLimb/RadarDish
var radar_offset = Vector2(-5, 20)
var radar_original_position : Vector2

@onready var satellite_limb = $SatelliteLimb
var satellite_offset = Vector2(10, 5)
var satellite_original_position : Vector2

@onready var center_limb = $CenterLimb
@onready var muzzle_flash_l = $CenterLimb/ChainGunL/MuzzleFlashL
@onready var muzzle_flash_l_timer = $CenterLimb/ChainGunL/MuzzleFlashLTimer
@onready var muzzle_flash_r = $CenterLimb/ChainGunR/MuzzleFlashR
@onready var muzzle_flash_r_timer = $CenterLimb/ChainGunR/MuzzleFlashRTimer
@onready var chain_gun_sound = $CenterLimb/ChainGunSound

@onready var chain_gun_l_shoot_point = $CenterLimb/ChainGunL/ChainGunLShootPoint
@onready var chain_gun_r_shoot_point = $CenterLimb/ChainGunR/ChainGunRShootPoint
@onready var radar_shoot_point = $RadarLimb/RadarDish/RadarShootPoint
@onready var satellite_shoot_point = $SatelliteLimb/Satellite/SatelliteShootPoint

func shoot_chain_gun_l():
	muzzle_flash_l.show()
	muzzle_flash_l_timer.start()
	chain_gun_sound.play()

func hide_muzzle_flash_l():
	muzzle_flash_l.hide()

func shoot_chain_gun_r():
	muzzle_flash_r.show()
	muzzle_flash_r_timer.start()
	chain_gun_sound.play()

func hide_muzzle_flash_r():
	muzzle_flash_r.hide()

func _ready():
	radar_original_position = radar_limb.position
	satellite_original_position = satellite_limb.position
	center_limb.setup(self)
	satellite_limb.setup(self)
	radar_limb.setup(self)

func _physics_process(_delta : float):
	var idle_percent = abs((idle_timer.wait_time / 2 - idle_timer.time_left) / (idle_timer.wait_time / 2))
	var idle_smooth = 0.5 - 0.5 * cos(idle_percent * PI)
	
	radar_limb.position = radar_original_position + radar_offset * idle_smooth
	satellite_limb.position = satellite_original_position + satellite_offset * idle_smooth
	
	waterloo_ring.rotation += deg_to_rad(ring_spin_speed)
