extends Node

var asteroid_large_scene : PackedScene = preload("res://scenes/asteroid_large_white.tscn")
var asteroid_medium_scene : PackedScene = preload("res://scenes/asteroid_medium_white.tscn")
var asteroid_small_scene : PackedScene = preload("res://scenes/asteroid_small_white.tscn")

enum asteroid_size  {LARGE,MEDIUM,SMALL}
var current_asteroid_size_to_build = asteroid_size.LARGE
var starting_asteroid_count = 4
var asteroidCount

var screensize 

var level_dictionary
var level_data

func buildScene() :
	level_data = get_parent().level_data
	print("Inside asteroidBuilder " )
	print(level_data)
	asteroidCount = level_data.LargeAsteroidCount
	$AsteroidSpawnTimer.wait_time = level_data.AsteroidSpawnTime
	screensize = get_parent().get_viewport_rect().size
	$AsteroidSpawnTimer.start()
	
func build_asteroid() :
	if(asteroidCount >0) :
		asteroidCount -= 1
		var asteroid 
		if(current_asteroid_size_to_build == asteroid_size.LARGE) :
			asteroid = asteroid_large_scene.instantiate()
		if(current_asteroid_size_to_build == asteroid_size.MEDIUM) :
			asteroid = asteroid_medium_scene.instantiate()
		elif(current_asteroid_size_to_build == asteroid_size.SMALL) :
			asteroid = asteroid_small_scene.instantiate()
			
		var sprite_names = asteroid.get_node("Sprite2D").sprite_frames.get_animation_names()
		#print(sprite_names)
		asteroid.get_node("Sprite2D").play(sprite_names[randi()%sprite_names.size()])
		var asteroid_spawn_location = get_parent().get_node("AsteroidPath/AsteroidPathFollow2D")
		asteroid_spawn_location.progress_ratio = randf()
		#asteroid_spawn_location.progress_ratio = 0.5
		var direction = asteroid_spawn_location.rotation + PI / 2
		# Set the asteroid's position to a random location.
		asteroid.position = asteroid_spawn_location.position
		#print("screen size " + str(screensize))
		#print("Spawn Location " + str(asteroid.position))
		# Add some randomness to the direction.
		direction += randf_range(-PI / 4, PI / 4)
		asteroid.rotation = direction

		# Choose the velocity for the asteroid.
		var velocity = Vector2(randf_range(level_data.AsteroidTopSpeed, 100.0), 0.0)
		asteroid.linear_velocity = velocity.rotated(direction)
		asteroid.add_to_group("Asteroids")
		get_parent().add_child(asteroid)
		
	else :
		$AsteroidSpawnTimer.stop()
		if current_asteroid_size_to_build == asteroid_size.LARGE :
			asteroidCount = level_data.MediumAsteroidCount
			current_asteroid_size_to_build = asteroid_size.MEDIUM
			$AsteroidSpawnTimer.start()
		elif  current_asteroid_size_to_build == asteroid_size.MEDIUM :
			asteroidCount = level_data.SmallAsteroidCount
			current_asteroid_size_to_build = asteroid_size.SMALL
			$AsteroidSpawnTimer.start()


func _on_asteroid_spawn_timer_timeout():
	build_asteroid()
