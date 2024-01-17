extends Node2D

var asteroid_scene_1 : PackedScene = preload("res://scenes/asteroid_large_white.tscn")
var asteroid_scene_2 : PackedScene = preload("res://scenes/asteroid_small_white.tscn")
var player_scene : PackedScene = preload("res://scenes/player.tscn")

var asteroidCount = 4

func _ready():
	setup_game()

func setup_game() :
	build_player()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	Globals.connect("level_change", next_level)
	Globals.connect("ship_change", check_for_game_over)
	Globals.ships = Globals.ships_starting_amount
	Globals.score = 0

func _on_asteroid_spawn_timer_timeout():
	build_asteroids()

func build_asteroids() :
	if(asteroidCount >0) :
		asteroidCount -= 1
		var asteroid = asteroid_scene_1.instantiate()
		#var asteroid = Globals.build_small_asteroid()
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
		#print("Before adding to group Asteroids left : " + str(get_tree().get_nodes_in_group("Asteroids").size()) )
		asteroid.add_to_group("Asteroids")
		# Spawn the mob by adding it to the Main scene.
		add_child(asteroid)
		#print("Asteroids left : " + str(get_tree().get_nodes_in_group("Asteroids").size()) )
		
	else :
		$AsteroidSpawnTimer.stop()

func build_player() :
	#print("build_player")
	var player_node = player_scene.instantiate()
	add_child(player_node)
	return player_node

func next_level():
	print("Inside $Level.next_level()")
	#$Player.queue_free()
	$MessageLabel.text = "Next Level"
	$MessageLabel.show()
	Globals.level += 1
	if Globals.level%3 == 0 :
		Globals.ships += 1
	
	$NextLevelTimer.start()


func _on_next_level_timer_timeout():
	$MessageLabel.hide()
	build_player()
	build_asteroids()

func check_for_game_over() :
	if Globals.ships <= 0 :
		print(" Game Over?")
		#var player_array = get_tree().get_nodes_in_group("Player")
		#var player = player_array[0]
		##get_groups()
		##player.remove_from_group("Player")
		#player.queue_free()
		#var asteroids = get_tree().get_nodes_in_group("Asteroids")
		#for n in asteroids :
			#n.remove_from_group("Asteroids")
			#n.queue_free()
		#$UserInterface.game_over()

