extends Node

enum AsteroidSize {LARGE,MEDIUM,SMALL}

var level_dictionary
var level_data

var max_level  = 4

enum game_state_enum {TITLE, NEW_GAME, RUNNING, PAUSE, HELL}
var game_state : game_state_enum = game_state_enum.TITLE

func _ready():
	load_level_dictionary()
	level_data = level_dictionary[0]

func load_level_dictionary() :
	var file = "res://data/LevelData.json"
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
		MsgQueue.send_score_change(score)

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

var ship_health_initial_value = 3
var ship_health = ship_health_initial_value :
	get :
		return ship_health
	set(value):
		ship_health = value
		MsgQueue.send_ship_health()

#Used when starting a new game
func reset_game_data() :
	ship_health = ship_health_initial_value
	level = 1
	level_data = level_dictionary[level]
	score = score_starting_amount 
	ships = ships_starting_amount
