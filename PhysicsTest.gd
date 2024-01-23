extends Node2D

var asteroid_large_scene : PackedScene = preload("res://scenes/derived_large_asteroid.tscn")
var asteroid_medium_scene : PackedScene = preload("res://scenes/derived_medium_asteroid.tscn")
var asteroid_small_scene : PackedScene = preload("res://scenes/derived_small_asteroid.tscn")

func _ready():
	
	var big_as = asteroid_large_scene.instantiate()
	big_as.position = Vector2(1000,100)
	big_as.linear_velocity = Vector2(-200,0)
	big_as.mass = 1000
	add_child(big_as)

	var big_as2 = asteroid_large_scene.instantiate()
	big_as2.position = Vector2(1000,300)
	big_as2.linear_velocity = Vector2(-200,0)
	big_as2.mass = 1000
	add_child(big_as2)

	var medium_as = asteroid_medium_scene.instantiate()
	medium_as.position = Vector2(500,100)
	medium_as.linear_velocity = Vector2(300,0)
	medium_as.mass = 300
	add_child(medium_as)

	var medium_as2 = asteroid_medium_scene.instantiate()
	medium_as2.position = Vector2(500,320)
	medium_as2.linear_velocity = Vector2(300,0)
	medium_as2.mass = 300
	add_child(medium_as2)

	var small_as = asteroid_small_scene.instantiate()
	small_as.position = Vector2(100,100)
	small_as.linear_velocity = Vector2(300,0)
	small_as.mass = 100
	add_child(small_as)
