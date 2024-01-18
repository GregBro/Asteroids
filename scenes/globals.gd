extends Node

var ships_starting_amount : int = 3
var ships : int = ships_starting_amount :
	get :
		#print("In globals get ships " + str(ships))
		return ships
	set(value):
		#print("In globals set ships. Value : " + str(value) + "  ships : " + str(ships))
		ships = value
		MsgQueue.send_ships_change()

var score_starting_amount : int = 0
var score = score_starting_amount
		

var level_starting_point : int = 1
var level = level_starting_point :
	get :
		return level
	set(value):
		level = value
		check_level()

var ship_health_initial_value = 1
var ship_health = ship_health_initial_value :
	get :
		return ship_health
	set(value):
		ship_health = value
		MsgQueue.send_ship_health()

func check_level() :
	if level % 3 == 0 :
		ships += 1
