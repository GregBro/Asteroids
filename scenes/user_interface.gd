extends CanvasLayer

signal level_change

func _ready():
	Globals.connect("ship_change", update_ships)
	Globals.connect("score_change", update_score)

func update_score() :
	$HBoxContainer2/ScoreAmoutLabel.text = str(Globals.score)
	#print("Inside update Score Asteroids left : " + str(get_tree().get_nodes_in_group("Asteroids").size()) )

func update_ships():
	$HBoxContainer/ShipCountLabel.text = str(Globals.ships)

func game_over() :
	$MessageLabel.text = "GAME OVER"
	$MessageLabel.show()
	$GameOverTimer.start()


func _on_game_over_timer_timeout():
	$MessageLabel.text = "Ready"
	$MessageLabel.show()
	$ReadyTimer.start()


func _on_ready_timer_timeout():
	$MessageLabel.hide()
	get_parent()
