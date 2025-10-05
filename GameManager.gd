extends Node

var player : Actor
var camera : Camera2D
var boss : Boss

var player_max_health = 100.0

func get_screen_box() -> Rect2:
	var result = camera.get_viewport_rect()
	result.size.x *= 2
	result.size.y *= 2
	result.position.x -= result.size.x / 2
	result.position.y -= result.size.y / 2
	return result
