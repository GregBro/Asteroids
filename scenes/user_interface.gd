extends CanvasLayer

func _ready():
	$HBoxContainer2/ScoreLabel.text = str(Globals.score_starting_amount)
	$HBoxContainer/ShipsCountLabel.text = str(Globals.ships_starting_amount)
	MsgQueue.connect("score_change", score_change)
	MsgQueue.connect("ship_change", ship_change)
	MsgQueue.connect("ship_health", ship_health)
	
func score_change(score) :
	$HBoxContainer2/ScoreLabel.text = str(score)

func ship_change(ships) :
	#print("Inside UI ship_change. ships : " + str(ships))
	$HBoxContainer/ShipsCountLabel.text = str(ships )

func ship_health(health) :
	#print("Received Health Signal : " + str(health))
	$HBoxContainer3/HealthProgressBar.value = health
