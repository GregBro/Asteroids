extends Node2D


enum difficulty_enum {NORMAL,HARD,SERIOUSLY,HELL}
var difficulty : difficulty_enum  = difficulty_enum.NORMAL:
	get :
		return difficulty
	set(value):
		#$TitleOverlay.hide()
		difficulty = value

var screensize 
var level_data

var player_scene : PackedScene = preload("res://scenes/player.tscn")
var laser_scene : PackedScene = preload("res://scenes/laser.tscn")
var asteroid_hit_scene : PackedScene = preload("res://scenes/asteroid_hit_animation.tscn")

func _ready():
	#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	MsgQueue.connect("level_change", level_change)
	MsgQueue.connect("fire_laser", fire_laser)
	MsgQueue.connect("asteroid_hit", asteroid_hit)
	MsgQueue.connect("lose_ship", lose_ship)
	screensize = get_viewport_rect().size
	level_data = Globals.level_data
	print(level_data)
	$AsteroidBuilder.buildScene()
	#print(InputMap.get_actions())

func _process(_delta):
	if Input.is_action_pressed("ui_cancel") :
	# Replace this with pause screen
		get_tree().paused = true
		$TitleOverlay.hide()
		$PauseOverlay.show()

func quit_game() :
	get_tree().quit()

func level_change(level) :
	print ("Got to level change")
	print ("level is " + str(level))
	level_data = Globals.level_data
	Globals.ships += level_data.ShipsAdded
	print(level_data)
	$UI/MsgLabel.text = "Ready"
	$UI/MsgLabel.show()
	$ReadyTimer.start()

func build_player() :
	#print ("Inside build_player the level is " + str(Globals.level))
	#print("build_player")
	if  level_data.PlayerEnabled :
		var player_node = player_scene.instantiate()
		Globals.ship_health = Globals.ship_health_initial_value
		player_node.position = Vector2(screensize.x/2, screensize.y/2)
		add_child(player_node)
		player_node.add_to_group("Player")
		player_node.show()
		#Globals.ship_health = 3
	#return player_node

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

func lose_ship() :
	if Globals.ships > 0 :
		$UI/MsgLabel.text = "Ready"
		$UI/MsgLabel.show()
		$ReadyTimer.start()
	else :
		game_over()

func _on_ready_timer_timeout():
		$UI/MsgLabel.text = ""
		$UI/MsgLabel.hide()
		var player_array = get_tree().get_nodes_in_group("Player")
		if player_array.size() == 0 :
			build_player()
		if Globals.game_state == Globals.game_state_enum.NEW_GAME :
			Globals.game_state = Globals.game_state_enum.RUNNING
			$AsteroidBuilder.buildScene()
		if Globals.game_state == Globals.game_state_enum.RUNNING :
			$AsteroidBuilder.rebuild_asteroids()
		

func game_over() :
	Globals.game_state = Globals.game_state_enum.NEW_GAME
	$UI/MsgLabel.text = "Game Over"
	$UI/MsgLabel.show()
	$GameOverTimer.start()


func _on_game_over_timer_timeout():
	$AsteroidBuilder.blow_up_all_asteroids()
	start_game()

func start_game() :
	Globals.reset_game_data()
	level_data = Globals.level_data
	$UI/MsgLabel.text = "Ready"
	$UI/MsgLabel.show()
	$NewGameTimer.start()

func _on_new_game_timer_timeout():
	$UI/MsgLabel.text = ""
	$UI/MsgLabel.hide()
	build_player()
	$AsteroidBuilder.buildScene()
	
