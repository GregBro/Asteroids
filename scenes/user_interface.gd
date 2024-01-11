extends CanvasLayer

signal next_level

func _ready():
	Globals.connect("ship_change", update_ships)
	Globals.connect("score_change", update_score)

func update_score() :
	$HBoxContainer2/ScoreAmoutLabel.text = str(Globals.score)
	print("Asteroids left : " + str(get_tree().get_nodes_in_group("Asteroids").size()) )
	if get_tree().get_nodes_in_group("Asteroids").size() == 1 :
		next_level.emit()
		

func update_ships():
	$HBoxContainer/ShipCountLabel.text = str(Globals.ships)

	
	
	
