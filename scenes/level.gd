extends Node2D

enum difficulty_enum {NORMAL,HARD,SERIOUSLY,HELL}
var difficulty : difficulty_enum  = difficulty_enum.NORMAL

var screensize 
var level_data
var is_pauseable : bool = true

var player_scene : PackedScene = preload("res://scenes/player.tscn")
var laser_scene : PackedScene = preload("res://scenes/laser.tscn")
var asteroid_hit_scene : PackedScene = preload("res://scenes/asteroid_hit_animation.tscn")

var laser_sounds = ["res://Audio/151011__bubaproducer__laser-classic-shot-4.ogg",
				"res://Audio/151012__bubaproducer__laser-classic-shot-3.ogg",
				"res://Audio/151013__bubaproducer__laser-classic-shot-2.ogg",
				"res://Audio/151024__bubaproducer__laser-shot-small-2.ogg",
				"res://Audio/151025__bubaproducer__laser-shot-small-1.ogg"]


func _ready():
	Logger.set_logger_level(Logger.LOG_LEVEL_ERROR)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	MsgQueue.connect("level_change", level_change)
	MsgQueue.connect("fire_laser", fire_laser)
	MsgQueue.connect("asteroid_hit", asteroid_hit)
	MsgQueue.connect("lose_ship", lose_ship)
	MsgQueue.connect("start_game", start_game)
	screensize = get_viewport_rect().size
	level_data = Globals.level_data
	#print(level_data)
	$AsteroidBuilder.buildScene()
	#$AudioStreamPlayer.stream = "res://Audio/ShortCannonBoom.ogg"
	#print(InputMap.get_actions())


func _process(_delta):
	if Input.is_action_pressed("ui_cancel")  &&  Globals.game_state != Globals.game_state_enum.TITLE && is_pauseable:
	# Replace this with pause screen
		is_pauseable = false
		if get_tree().paused :
			get_tree().paused = false
			$PauseOverlay.hide()
		else :
			$PauseOverlay.enable()
		$PauseTimer.start()
	if Input.is_action_pressed("ui_cancel") :
		pass


func quit_game() :
	get_tree().quit()


func level_change(level) :
	Logger.debug("Got to level change")
	Logger.debug("level is " + str(level))
	level_data = Globals.level_data
	Globals.ships += level_data.ShipsAdded
	Globals.game_state = Globals.game_state_enum.LEVEL_CHANGE
	Logger.debug(str(level_data))
	$UI/MsgLabel.text = "Ready"
	$UI/MsgLabel.show()
	$ReadyTimer.start()


func build_player() :
	if  level_data.PlayerEnabled :
		var player_node = player_scene.instantiate()
		Globals.ship_health = Globals.ship_health_initial_value
		player_node.position = Vector2(screensize.x/2, screensize.y/2)
		add_child(player_node)
		player_node.add_to_group("Player")
		player_node.show()


func fire_laser(player_pos,player_direction):
	#AudioStreamManager.play(laser_sounds[randi()%laser_sounds.size()])
	var laser = laser_scene.instantiate()
	laser.rotation_degrees = rad_to_deg(player_direction) 
	laser.direction = Vector2.RIGHT.rotated(player_direction)
	laser.position = player_pos + (laser.direction * 50)
	laser.add_to_group("Lasers")
	add_child(laser)


func asteroid_hit(asteroid_position) :
	AudioStreamManager.play("res://Audio/ShortCannonBoom.ogg")
	#$AudioStreamPlayer.play()
	var asteroid_hit_instance = asteroid_hit_scene.instantiate()
	asteroid_hit_instance.position = asteroid_position
	asteroid_hit_instance.show()
	asteroid_hit_instance.play()
	add_child(asteroid_hit_instance)
	MsgQueue.send_score_change(10)


func lose_ship() :
	if Globals.ships > 0 :
		Globals.game_state = Globals.game_state_enum.LOST_SHIP
		$UI/MsgLabel.text = "Ready"
		$UI/MsgLabel.show()
		$ReadyTimer.start()
	else :
		game_over()


func _on_ready_timer_timeout():
	$UI/MsgLabel.text = ""
	$UI/MsgLabel.hide()
	var player_array = get_tree().get_nodes_in_group("Player")
	if Globals.game_state == Globals.game_state_enum.NEW_GAME :
		if player_array.size() == 0 :
			build_player()
		Globals.game_state = Globals.game_state_enum.RUNNING
		$AsteroidBuilder.buildScene()
		
	if Globals.game_state == Globals.game_state_enum.LOST_SHIP :
		if player_array.size() == 0 :
			build_player()
		Globals.game_state = Globals.game_state_enum.RUNNING 
		
	if Globals.game_state == Globals.game_state_enum.LEVEL_CHANGE :
		if player_array.size() == 0 :
			build_player()
		Globals.game_state = Globals.game_state_enum.RUNNING 
		$AsteroidBuilder.rebuild_asteroids()


func game_over() :
	Globals.game_state = Globals.game_state_enum.TITLE
	$UI/MsgLabel.text = "Game Over"
	$UI/MsgLabel.show()
	$GameOverTimer.start()


func _on_game_over_timer_timeout():
	Globals.game_state = Globals.game_state_enum.GAME_OVER
	$AsteroidBuilder.blow_up_all_asteroids()
	Globals.game_state = Globals.game_state_enum.TITLE
	$UI/MsgLabel.hide()
	$UI.hide()
	$TitleOverlay.show()
	$TitleOverlay.reset_buttons()


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


func _on_pause_timer_timeout():
	is_pauseable = true


func _on_hell_mode_t_imer_timeout():
	var asteroid_size = randi()%3
	match asteroid_size :
		0: $AsteroidBuilder.current_asteroid_size_to_build = Globals.AsteroidSize.LARGE
		1: $AsteroidBuilder.current_asteroid_size_to_build = Globals.AsteroidSize.MEDIUM
		2: $AsteroidBuilder.current_asteroid_size_to_build = Globals.AsteroidSize.SMALL
	$AsteroidBuilder.buildAsteroid()
			
	
	#$AsteroidBuilder
