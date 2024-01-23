extends Node2D

var asteroid_large_scene : PackedScene = preload("res://scenes/derived_large_asteroid.tscn")
var asteroid_small_scene : PackedScene = preload("res://scenes/unique_small_asteroid.tscn")

func _ready():
	
	var big_as = asteroid_large_scene.instantiate()
	big_as.position = Vector2(600,100)
	big_as.linear_velocity = Vector2(-200,0)
	big_as.mass = 1000
	add_child(big_as)

	var small_as = asteroid_small_scene.instantiate()
	small_as.position = Vector2(100,100)
	small_as.linear_velocity = Vector2(300,0)
	small_as.mass = 100
	add_child(small_as)
