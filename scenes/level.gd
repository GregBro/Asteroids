extends Node2D

var asteroid_scene_1 : PackedScene = preload("res://scenes/asteroid_large_white.tscn")

var asteroidCount = 4

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	$UserInterface/HBoxContainer/ShipCountLabel.text = str(Globals.ships)
	
	
func _on_asteroid_spawn_timer_timeout():
	if(asteroidCount >0) :
		asteroidCount -= 1
		var asteroid = asteroid_scene_1.instantiate()
		var asteroid_spawn_location = get_node("AsteroidPath/AsteroidPathFollow2D")
		asteroid_spawn_location.progress_ratio = randf()
		var direction = asteroid_spawn_location.rotation + PI / 2
		# Set the asteroid's position to a random location.
		asteroid.position = asteroid_spawn_location.position

		# Add some randomness to the direction.
		direction += randf_range(-PI / 4, PI / 4)
		asteroid.rotation = direction

		# Choose the velocity for the mob.
		var velocity = Vector2(randf_range(120.0, 100.0), 0.0)
		asteroid.linear_velocity = velocity.rotated(direction)
		#asteroid.speed_x = velocity.x
		#asteroid.speed_y = velocity.y
		asteroid.add_to_group("Asteroids")
		# Spawn the mob by adding it to the Main scene.
		add_child(asteroid)
	else :
		$AsteroidSpawnTimer.stop()
