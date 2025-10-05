extends Attack

@export var vaccine : PackedScene
@export var shots = 20
@export var fire_delay = 0.12

var rotation_step = 20
var current_rotation = 0
var multishot = 6

func _ready():
	for i in range(shots):
		
		boss_ref.shoot_chain_gun_l()
		for j in range(multishot):
			var new_vaccine = vaccine.instantiate()
			new_vaccine.global_position = boss_ref.chain_gun_l_shoot_point.global_position
			new_vaccine.rotation = deg_to_rad(current_rotation + (360.0 / multishot) * j)
			new_vaccine.velocity = Vector2(cos(new_vaccine.rotation), sin(new_vaccine.rotation)).normalized() * new_vaccine.speed
			get_tree().get_root().add_child(new_vaccine)
		
		await get_tree().create_timer(fire_delay).timeout
		current_rotation += rotation_step
		
		boss_ref.shoot_chain_gun_r()
		for j in range(multishot):
			var new_vaccine = vaccine.instantiate()
			new_vaccine.global_position = boss_ref.chain_gun_r_shoot_point.global_position
			new_vaccine.rotation = deg_to_rad(current_rotation + (360.0 / multishot) * j)
			new_vaccine.velocity = Vector2(cos(new_vaccine.rotation), sin(new_vaccine.rotation)).normalized() * new_vaccine.speed
			get_tree().get_root().add_child(new_vaccine)
		
		await get_tree().create_timer(fire_delay).timeout
		current_rotation += rotation_step
	
	finished()
	queue_free()
