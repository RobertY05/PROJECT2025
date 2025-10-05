extends Actor
class_name Boss

@export var healthbar : PackedScene

@export var attacks : Array[PackedScene]
@export var attack_wait := 2.0
var attack_index := attacks.size()

@onready var timer_ref : Timer

func start():
	timer_ref = Timer.new()
	
	add_child(timer_ref)
	timer_ref.wait_time = attack_wait
	timer_ref.one_shot = true
	timer_ref.timeout.connect(attack_timer_timeout)
	
	timer_ref.start()
	
	var new_healthbar = healthbar.instantiate()
	get_tree().get_root().add_child(new_healthbar)
	new_healthbar.setup(self)

func next_attack():
	timer_ref.start()

func attack_timer_timeout():
	if attack_index == attacks.size():
		attacks.shuffle()
		attack_index = 0
	
	var new_attack : Attack = attacks[attack_index].instantiate()
	new_attack.setup(self, health)
	add_child(new_attack)
	
	attack_index += 1
