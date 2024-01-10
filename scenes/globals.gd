extends Node

var ships_starting_amount : int = 3
var ships : int = 3

var score_starting_amount : int = 0
var score : int = 0

func update_ship_count(increment:int) :
	ships += increment
	print("Ships : " + str(ships))
	
# check for new game
