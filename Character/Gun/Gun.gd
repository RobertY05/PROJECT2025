extends Node2D

@export var magazine_size := 30
@export var fire_delay := 0.1
@export var reload_time := 1.0
@export var damage := 10.0
@export var knockback := 50.0
@export var bloom := 3.0

@export var decal : PackedScene

@onready var fire_timer = $FireTimer
@onready var reload_mag_in_timer = $ReloadMagInTimer
@onready var reload_rack_timer = $ReloadRackTimer
@onready var reload_timer = $ReloadTimer
@onready var muzzle_flash_timer = $MuzzleFlashTimer

@onready var gunshot_sound = $GunshotSound
@onready var mag_out_sound = $MagOutSound
@onready var mag_in_sound = $MagInSound
@onready var rack_sound = $RackSound

@onready var gun_image = $M16
@onready var gun_empty_image = $M16Empty

@onready var muzzle_flashes = [$MuzzleFlash1, $MuzzleFlash2, $MuzzleFlash3]

@onready var raycast = $RayCast2D

var reload_mag_in_percent = 0.2
var reload_rack_percent = 0.4

var reload_mag_out_force = 5
var reload_mag_in_force = 10
var reload_rack_force = 20
var recoil_force = 5
var lerp_percent = 0.1

var magazine : int
var facing_right = true
var original_position : Vector2

func reload():
	eject_mag()
	reload_mag_in_timer.start()
	reload_rack_timer.start()
	reload_timer.start()

func eject_mag():
	mag_out_sound.play()
	gun_empty_image.show()
	gun_image.hide()
	
	var force = Vector2.ZERO
	if facing_right:
		force.y += reload_mag_out_force
	else:
		force.y -= reload_mag_out_force
	position += force.rotated(rotation)

func new_mag():
	mag_in_sound.play()
	gun_empty_image.hide()
	gun_image.show()
	
	var force = Vector2.ZERO
	if facing_right:
		force.y -= reload_mag_in_force
	else:
		force.y += reload_mag_in_force
	position += force.rotated(rotation)

func rack_gun():
	rack_sound.play()
	
	var force = Vector2(-reload_rack_force, 0)
	position += force.rotated(rotation)

func finish_reload():
	magazine = magazine_size

func shoot():
	gunshot_sound.play()
	fire_timer.start()
	
	raycast.target_position = get_local_mouse_position().normalized()
	var bloom_rot = deg_to_rad(randf_range(-bloom, bloom))
	raycast.target_position.x = raycast.target_position.x * cos(bloom_rot) - raycast.target_position.y * sin(bloom_rot)
	raycast.target_position.y = raycast.target_position.x * sin(bloom_rot) + raycast.target_position.y * cos(bloom_rot)
	raycast.target_position *= 99999999
	
	raycast.force_raycast_update()
	if raycast.is_colliding():
		var new_decal = decal.instantiate()
		new_decal.global_position = raycast.get_collision_point()
		get_tree().get_root().add_child(new_decal)
		if raycast.get_collider() is Actor:
			var actor : Actor = raycast.get_collider()
			actor.hurt(damage, (actor.global_position - global_position).normalized() * knockback)
	
	var force = Vector2(-recoil_force, 0)
	position += force.rotated(rotation)
	
	hide_muzzle_flash()
	
	muzzle_flash_timer.start()
	muzzle_flashes.pick_random().show()
	magazine -= 1

func hide_muzzle_flash():
	for flash in muzzle_flashes:
		flash.hide()

func _ready():
	fire_timer.wait_time = fire_delay
	reload_mag_in_timer.wait_time = reload_time * reload_mag_in_percent
	reload_rack_timer.wait_time = reload_time * reload_rack_percent + reload_mag_in_timer.wait_time
	reload_timer.wait_time = reload_time
	
	magazine = magazine_size
	original_position = position

func _process(_delta : float):
	if Input.is_action_pressed("shoot") and fire_timer.is_stopped() and reload_timer.is_stopped():
		if magazine > 0:
			shoot()
		else:
			reload()
	
	if Input.is_action_pressed("reload") and reload_timer.is_stopped() and magazine < magazine_size:
		reload()
	
	if get_global_mouse_position().x < global_position.x:
		scale.y = -1
		facing_right = false
	else:
		scale.y = 1
		facing_right = true
	
	look_at(get_global_mouse_position())

func _physics_process(_delta : float):
	position = lerp(position, original_position, lerp_percent)
