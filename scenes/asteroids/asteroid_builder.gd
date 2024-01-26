extends Node

var asteroid_large_scene : PackedScene = preload("res://scenes/asteroids/derived_large_asteroid.tscn")
var asteroid_medium_scene : PackedScene = preload("res://scenes/asteroids/derived_medium_asteroid.tscn")
var asteroid_small_scene : PackedScene = preload("res://scenes/asteroids/derived_small_asteroid.tscn")

var current_asteroid_size_to_build =  Globals.AsteroidSize.LARGE
var starting_asteroid_count = 4
var asteroidCount

var screensize 

var level_dictionary
var level_data

func _ready():
	screensize = get_parent().get_viewport_rect().size
	MsgQueue.connect("asteroid_breakup", asteroid_breakup)

func buildScene() :
	level_data = get_parent().level_data
	print("Inside asteroidBuilder " )
	print(level_data)
	asteroidCount = level_data.LargeAsteroidCount
	$AsteroidSpawnTimer.wait_time = level_data.AsteroidSpawnTime
	$AsteroidSpawnTimer.start()

func build_asteroid() :
	if(asteroidCount >0) :
		asteroidCount -= 1
		var asteroid 
		if(current_asteroid_size_to_build == Globals.AsteroidSize.LARGE) :
			asteroid = asteroid_large_scene.instantiate()
		if(current_asteroid_size_to_build == Globals.AsteroidSize.MEDIUM) :
			asteroid = asteroid_medium_scene.instantiate()
		elif(current_asteroid_size_to_build == Globals.AsteroidSize.SMALL) :
			asteroid = asteroid_small_scene.instantiate()
			
		var sprite_names = asteroid.get_node("AnimatedSprite2D").sprite_frames.get_animation_names()
		#print(sprite_names)
		asteroid.get_node("AnimatedSprite2D").play(sprite_names[randi()%sprite_names.size()])
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
		if current_asteroid_size_to_build == Globals.AsteroidSize.LARGE :
			asteroidCount = level_data.MediumAsteroidCount
			current_asteroid_size_to_build = Globals.AsteroidSize.MEDIUM
			$AsteroidSpawnTimer.start()
		elif  current_asteroid_size_to_build == Globals.AsteroidSize.MEDIUM :
			asteroidCount = level_data.SmallAsteroidCount
			current_asteroid_size_to_build = Globals.AsteroidSize.SMALL
			$AsteroidSpawnTimer.start()

func _on_asteroid_spawn_timer_timeout():
	build_asteroid()

func blow_up_all_asteroids() :
	print ("Got to blow_up_all_asteroids")
	$AsteroidSpawnTimer.stop()
	var asteroid_array = get_tree().get_nodes_in_group("Asteroids")
	print ("Array size " + str(asteroid_array.size()))
	get_tree().call_group("Asteroids", "queue_free")

func asteroid_breakup(asteroid_position, direction, size) :
	#print("Got to Asteroid breakup in main")
	#print("Asteroid size is " + str(size))
	
	var asteroid_1
	var asteroid_2
	# A large asteroid broke up
	if size == 0 :
		asteroid_1 = asteroid_medium_scene.instantiate()
		asteroid_2 = asteroid_medium_scene.instantiate()
	elif size == 1 :
		asteroid_1 = asteroid_small_scene.instantiate()
		asteroid_2 = asteroid_small_scene.instantiate()
	else:
		var asteroids = get_tree().get_nodes_in_group("Asteroids")
		print("In Asteroid Breakup Asteroid count : " + str(asteroids.size()))
		return

	asteroid_1.position = asteroid_position	- Vector2(25,25)
	asteroid_2.position = asteroid_position	+ Vector2(25,25)	
	asteroid_1.linear_velocity = direction.rotated(-0.25) 
	asteroid_2.linear_velocity = direction.rotated(0.25) 

	asteroid_1.add_to_group("Asteroids")
	asteroid_2.add_to_group("Asteroids")

	asteroid_1.show()
	asteroid_2.show()
	
	call_deferred("add_child", asteroid_1)
	call_deferred("add_child", asteroid_2)
