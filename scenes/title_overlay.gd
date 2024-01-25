extends CanvasLayer

func _ready() :
	$ExitButton.pressed.connect(self.quit_game)
	$VBoxContainer/NormalDifficultyButton.pressed.connect(self.set_level_normal)
	$VBoxContainer/HardDifficultyButton.pressed.connect(self.set_level_hard)
	$VBoxContainer/SeriouslyDifficultyButton.pressed.connect(self.set_level_seriously)
	$VBoxContainer/HellDifficultyButton.pressed.connect(self.set_level_hell)
	
func set_level_normal() :
	get_parent().difficulty = get_parent().difficulty_enum.NORMAL
	cleanup_overlay_start_game()

func set_level_hard() :
	get_parent().difficulty = get_parent().difficulty_enum.HARD
	cleanup_overlay_start_game()

func set_level_seriously() :
	get_parent().difficulty = get_parent().difficulty_enum.SERIOUSLY
	cleanup_overlay_start_game()

func set_level_hell() :
	get_parent().difficulty = get_parent().difficulty_enum.HELL
	cleanup_overlay_start_game()

func cleanup_overlay_start_game() :
	$".".hide()
	$"../AsteroidBuilder".blow_up_all_asteroids()
	print("Got here")
	Globals.level += 1
	#$"../".setup_game()
	
func quit_game() :
	print("Quit")
	get_parent().quit_game()
