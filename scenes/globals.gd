extends Node

var asteroid_large_scene : PackedScene = preload("res://scenes/asteroid_large_white.tscn")
var asteroid_medium_scene : PackedScene = preload("res://scenes/asteroid_medium_white.tscn")
var asteroid_small_scene : PackedScene = preload("res://scenes/asteroid_small_white.tscn")

var ships_starting_amount : int = 3
var ships : int = 3

var score_starting_amount : int = 0
var score : int = 0

func update_ship_count(increment:int) :
	ships += increment
	#print("Ships : " + str(ships))
	# check for new game

func update_score(increment:int):
	score += increment
	
func build_small_asteroid() :
	return asteroid_small_scene.instantiate()
	
func build_medium_asteroid() :
	return asteroid_medium_scene.instantiate()
