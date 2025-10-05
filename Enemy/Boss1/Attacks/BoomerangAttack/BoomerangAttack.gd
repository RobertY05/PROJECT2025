extends Attack

@export var boomerangScene : PackedScene
@export var shots := 6
@export var fire_cooldown := 1
@export var return_cooldown := 3.5

func _ready():
	await shoot()
	await get_tree().create_timer(return_cooldown).timeout
	finished()
	queue_free()

func shoot():
	for i in range(shots):
		var boomerang = boomerangScene.instantiate()
		boomerang.global_position = boss_ref.radar_shoot_point.global_position
		boomerang.target = self
		boomerang.velocity = (GameManager.player.global_position - boomerang.global_position).normalized() * boomerang.speed 
		get_tree().get_root().add_child(boomerang)
		await get_tree().create_timer(fire_cooldown).timeout
