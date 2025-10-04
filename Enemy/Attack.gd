@abstract class_name Attack
extends Node2D

var hp_percent : float
var boss_ref : Boss

func setup(boss : Boss, hp_in : float) -> void:
	hp_percent = hp_in
	boss_ref = boss

func finished():
	boss_ref.next_attack()
