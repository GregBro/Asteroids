extends CanvasLayer

var can_select : bool = true


func _ready() :
	$ExitButton.pressed.connect(self.quit_game)
	$VBoxContainer/NormalDifficultyButton.pressed.connect(self.set_level_normal)
	$VBoxContainer/HardDifficultyButton.pressed.connect(self.set_level_hard)
	$VBoxContainer/SeriouslyDifficultyButton.pressed.connect(self.set_level_seriously)
	$VBoxContainer/HellDifficultyButton.pressed.connect(self.set_level_hell)
	$VBoxContainer/NormalDifficultyButton.grab_focus()
	#Logger.debug(str(group.get_buttons()))


func _process(_delta):
	pass


func _on_selection_timer_timeout():
	can_select = true


func set_level_normal() :
	get_parent().difficulty = get_parent().difficulty_enum.NORMAL
	cleanup_overlay_start_game("normal")


func set_level_hard() :
	get_parent().difficulty = get_parent().difficulty_enum.HARD
	cleanup_overlay_start_game("hard")


func set_level_seriously() :
	get_parent().difficulty = get_parent().difficulty_enum.SERIOUSLY
	cleanup_overlay_start_game("seriously")


func set_level_hell() :
	get_parent().difficulty = get_parent().difficulty_enum.HELL
	cleanup_overlay_start_game("hell")


func cleanup_overlay_start_game(difficulty) :
	self.hide()
	Globals.load_level_dictionary(difficulty)
	get_parent().get_node("UI").show()
	get_parent().get_node("AsteroidBuilder").blow_up_all_asteroids()
	#Logger.debug("level is " + str(Globals.level))
	#Logger.debug("Game state is " + str(Globals.game_state))
	Globals.game_state = Globals.game_state_enum.NEW_GAME
	Globals.level +=1
	Globals.score = Globals.score_starting_amount
	Globals.ships = Globals.ships_starting_amount
	#Logger.debug("After resetting")
	#Logger.debug("level is " + str(Globals.level))
	#Logger.debug("Game state is " + str(Globals.game_state))


func quit_game() :
	Logger.debug("Quit Game")
	get_parent().quit_game()

func reset_buttons() :
	$VBoxContainer/NormalDifficultyButton.grab_focus()


