extends Node2D

@onready var bar = $TextureProgressBar

var dead = false
var fade_speed = 0.05
var boss_ref : Boss

func setup(boss : Boss):
	bar.min_value = 0
	bar.max_value = boss.health
	modulate.a = 0
	boss_ref = boss

func _process(_delta):
	if boss_ref != null and boss_ref.health <= 0:
		dead = true
	if boss_ref != null:
		bar.value = boss_ref.health

func _physics_process(_delta):
	if dead:
		modulate.a = max(0, modulate.a - fade_speed)
	else:
		modulate.a = min(1, modulate.a + fade_speed)
	if dead and modulate.a <= 0.01:
		queue_free()
