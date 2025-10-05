extends Attack

@export var vaccine : PackedScene
@export var shots = 30

@onready var timer_l = $TimerL
@onready var timer_r = $TimerR

func _ready():
	timer_l.start()

func shoot_l():
	if shots > 0:
		shots -= 1
		timer_r.start()
		boss_ref.shoot_chain_gun_l()
		var new_vaccine = vaccine.instantiate()
		new_vaccine.global_position = boss_ref.chain_gun_l_shoot_point.global_position
		new_vaccine.velocity = (GameManager.player.global_position - global_position).normalized() * new_vaccine.speed
		new_vaccine.look_at(GameManager.player.global_position)
		get_tree().get_root().add_child(new_vaccine)
	else:
		finished()
		queue_free()

func shoot_r():
	if shots > 0:
		shots -= 1
		timer_l.start()
		boss_ref.shoot_chain_gun_r()
		var new_vaccine = vaccine.instantiate()
		new_vaccine.global_position = boss_ref.chain_gun_r_shoot_point.global_position
		new_vaccine.velocity = (GameManager.player.global_position - global_position).normalized() * new_vaccine.speed
		new_vaccine.look_at(GameManager.player.global_position)
		get_tree().get_root().add_child(new_vaccine)
	else:
		finished()
		queue_free()
