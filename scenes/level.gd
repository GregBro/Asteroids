extends Node2D

var asteroid_large_scene : PackedScene = preload("res://scenes/asteroid_large_white.tscn")
var asteroid_medium_scene : PackedScene = preload("res://scenes/asteroid_medium_white.tscn")
var asteroid_small_scene : PackedScene = preload("res://scenes/asteroid_small_white.tscn")
var player_scene : PackedScene = preload("res://scenes/player.tscn")
var laser_scene : PackedScene = preload("res://scenes/laser.tscn")
var asteroid_hit_scene : PackedScene = preload("res://scenes/asteroid_hit_animation.tscn")

enum asteroid_size  {LARGE,MEDIUM,SMALL}
var current_asteroid_size_to_build = asteroid_size.LARGE
var starting_asteroid_count = 4
var asteroidCount

var screensize 

var level_dictionary
var level_data

func _ready():
	screensize = get_viewport_rect().size
	MsgQueue.connect("fire_laser", fire_laser)
	MsgQueue.connect("asteroid_hit", asteroid_hit)
	MsgQueue.connect("asteroid_breakup", asteroid_breakup)
	MsgQueue.connect("lose_ship", lose_ship)
	#MsgQueue.connect("rebuild_asteroids", start_asteroid_spawn_timer)
	Globals.ships = Globals.ships_starting_amount
	load_level_dictionary()
	setup_game()

func load_level_dictionary() :
	var file = "res://data/LevelData.json"
	var json_as_text = FileAccess.get_file_as_string(file)
	level_dictionary = JSON.parse_string(json_as_text)
	#print(level_dictionary)

func setup_game() :
	level_data = level_dictionary[Globals.level -1]
	level_data = level_dictionary[3]
	print(level_data)
	asteroidCount = level_data.LargeAsteroidCount
	$AsteroidSpawnTimer.wait_time = level_data.AsteroidSpawnTime
	build_player()
	Globals.ships += level_data.ShipsAdded
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	#Globals.connect("level_change", next_level)
	#Globals.connect("ship_change", check_for_game_over)
	#Globals.ships = Globals.ships_starting_amount
	#Globals.score = 0

func _on_asteroid_spawn_timer_timeout():
	#print("Building Asteroid")
	build_asteroid()

func start_asteroid_spawn_timer() :
	#asteroidCount = starting_asteroid_count
	#print("Starting Asteroid timer")
	$AsteroidSpawnTimer.start()

func build_player() :
	#print("build_player")
	var player_node = player_scene.instantiate()
	player_node.position = Vector2(screensize.x/2, screensize.y/2)
	add_child(player_node)
	player_node.add_to_group("Player")
	Globals.ship_health = 3
	#return player_node
	
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
		var asteroid_spawn_location = get_node("AsteroidPath/AsteroidPathFollow2D")
		asteroid_spawn_location.progress_ratio = randf()
		#asteroid_spawn_location.progress_ratio = 0.5
		var direction = asteroid_spawn_location.rotation + PI / 2
		# Set the asteroid's position to a random location.
		asteroid.position = asteroid_spawn_location.position
		print("screen size " + str(screensize))
		print("Spawn Location " + str(asteroid.position))

		# Add some randomness to the direction.
		direction += randf_range(-PI / 4, PI / 4)
		asteroid.rotation = direction

		# Choose the velocity for the asteroid.
		var velocity = Vector2(randf_range(120.0, 100.0), 0.0)
		asteroid.linear_velocity = velocity.rotated(direction)
		asteroid.add_to_group("Asteroids")
		add_child(asteroid)
		
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

func fire_laser(player_pos,player_direction):
	var laser = laser_scene.instantiate()
	laser.rotation_degrees = rad_to_deg(player_direction) 
	laser.direction = Vector2.RIGHT.rotated(player_direction)
	laser.position = player_pos + (laser.direction * 50)
	laser.add_to_group("Lasers")
	add_child(laser)

func asteroid_hit(asteroid_position) :
	#print("Asteroid Hit position : " + str(asteroid_position)) 
	var asteroid_hit_instance = asteroid_hit_scene.instantiate()
	asteroid_hit_instance.position = asteroid_position
	asteroid_hit_instance.show()
	asteroid_hit_instance.play()
	add_child(asteroid_hit_instance)
	MsgQueue.send_score_change(10)
	
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

func lose_ship() :
	var player_array = get_tree().get_nodes_in_group("Player")
	var player = player_array[0]
	player.queue_free()
	
	if Globals.ships <= 0 :
		lose_game()
	else :
		$UI/MsgLabel.text = "Ready"
		$UI/MsgLabel.show()
		$ReadyTimer.start()

func lose_game() :
	print("Game Over Event")
	$UI/MsgLabel.text = "Game Over"
	$UI/MsgLabel.show()
	var asteroid_array = get_tree().get_nodes_in_group("Asteroids")
	for a in asteroid_array :
		a.queue_free()
	$GameOverTimer.start()

func _on_ready_timer_timeout():
	$UI/MsgLabel.hide()
	build_player()


func _on_game_over_timer_timeout():
	$UI/MsgLabel.hide()
	Globals.level = Globals.level_starting_point
	#asteroidCount = starting_asteroid_count
	Globals.ships = Globals.ships_starting_amount
	setup_game()
	$AsteroidSpawnTimer.start()
