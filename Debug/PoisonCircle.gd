extends Area2D

var player : Actor = null

func _on_body_entered(body):
	if body is Actor and body.friendly:
		player = body

func _on_body_exited(body):
	if body is Actor and body.friendly:
		player = null



func _on_timer_timeout():
	if player != null:
		player.apply_poison(20)
