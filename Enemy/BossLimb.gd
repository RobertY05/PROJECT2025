extends Actor
class_name BossLimb

var boss_ref : Boss

func setup(boss : Boss):
	boss_ref = boss

func hurt(amount : float, force : Vector2 = Vector2.ZERO) -> void:
	boss_ref.hurt(amount, force)

func _physics_process(_delta : float):
	return
