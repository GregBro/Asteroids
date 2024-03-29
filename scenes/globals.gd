extends Node

enum AsteroidSize {LARGE,MEDIUM,SMALL}

var level_dictionary
var level_data

var max_level  = 4

enum game_state_enum {TITLE, GAME_OVER, LEVEL_CHANGE, NEW_GAME, RUNNING, PAUSE, HELL, LOST_SHIP}
var game_state : game_state_enum = game_state_enum.TITLE

func _ready():
	load_level_dictionary("normal")
	level_data = level_dictionary[0]


func load_level_dictionary(difficulty) :
	var file = "res://data/LevelData.json"
	if(difficulty == "hard") :
		file = "res://data/LevelDataHard.json"
	if(difficulty == "seriously") :
		file = "res://data/LevelDataSeriously.json"
	if(difficulty == "hell") :
		file = "res://data/LevelDataHell.json"
	var json_as_text = FileAccess.get_file_as_string(file)
	level_dictionary = JSON.parse_string(json_as_text)
	#print(level_dictionary)


var ships_starting_amount : int = 3
var ships : int = ships_starting_amount :
	get :
		return ships
	set(value):
		ships = value
		MsgQueue.send_ships_change()


var score_starting_amount : int = 0
var score : int = score_starting_amount :
	get :
		return score
	set(value):
		score = value
		MsgQueue.send_score_change()


var level_starting_point : int = 0
var level = level_starting_point :
	get :
		return level
	set(value):
		if value > max_level : 
			level = max_level
		else :
			level = value
		level_data = level_dictionary[level]
		MsgQueue.send_level_change()


var ship_health_initial_value = 30
var ship_health = ship_health_initial_value :
	get :
		return ship_health
	set(value):
		if value > ship_health_initial_value :
			value = ship_health_initial_value
		ship_health = value
		MsgQueue.send_ship_health()
		if ship_health <= 0 :
			var player_array = get_tree().get_nodes_in_group("Player")
			if player_array.size() >= 0 :
				player_array[0].queue_free()
			MsgQueue.send_lose_ship()


#Used when starting a new game
func reset_game_data() :
	ship_health = ship_health_initial_value
	level = 1
	level_data = level_dictionary[level]
	score = score_starting_amount 
	ships = ships_starting_amount

var weapon_heat_initial_value = 0
var weapon_heat_max_value = 30
var weapon_heat = weapon_heat_initial_value :
	get :
		return weapon_heat
	set(value):
		if(value <= weapon_heat_max_value &&  value > -1) :
			weapon_heat = value
		MsgQueue.send_weapon_heat()


func _on_heat_timer_timeout():
	weapon_heat -=2
