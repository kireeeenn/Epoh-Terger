extends Node

var current_health = Global.lives
var max_health = 200
var damage = 30

func set_player_health(health):
	Global.lives = health
