extends Node


signal ship_change
var ships_starting_amount : int = 3
var ships : int = 3 :
	get :
		return ships
	set(value):
		ships = value
		ship_change.emit()

signal score_change
var score_starting_amount : int = 0
var score : int = 0 :
	get :
		return score
	set(value):
		score = value
		score_change.emit()

signal level_change
var level_starting_point : int = 1
var level = level_starting_point :
	get :
		return level
	set(value):
		level = value
		level_change.emit()

	
var asteroid_large_scene : PackedScene = preload("res://scenes/asteroid_large_white.tscn")
var asteroid_medium_scene : PackedScene = preload("res://scenes/asteroid_medium_white.tscn")
var asteroid_small_scene : PackedScene = preload("res://scenes/asteroid_small_white.tscn")

func build_small_asteroid() :
	return asteroid_small_scene.instantiate()
	
func build_medium_asteroid() :
	return asteroid_medium_scene.instantiate()
