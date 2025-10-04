extends Node

var player : Actor
var camera : Camera2D

func get_screen_box():
	var result = camera.get_viewport_rect()
	result.size.x *= 2
	result.size.y *= 2
	result.position.x -= result.size.x / 2
	result.position.y -= result.size.y / 2
	return result
