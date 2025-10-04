extends Attack

@export var vaccine : PackedScene
@export var shots = 4
@export var fire_cooldown = 0.5

@onready var timer = $Timer

func _ready():
	shoot()
	timer.start(fire_cooldown)

func shoot():
	if shots > 0:
		shots -= 1
		timer.start(fire_cooldown)
		var new_vaccine = vaccine.instantiate()
		new_vaccine.global_position = global_position
		new_vaccine.velocity = (GameManager.player.global_position - global_position).normalized() * new_vaccine.speed
		get_tree().get_root().add_child(new_vaccine)
	else:
		boss_ref.next_attack()
		queue_free()
