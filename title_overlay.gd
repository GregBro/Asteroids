extends CanvasLayer

func _ready() :
	$ExitButton.pressed.connect(self.quit_game)
	$VBoxContainer/NormalDifficultyButton.pressed.connect(self.set_level_normal)
	$VBoxContainer/HardDifficultyButton.pressed.connect(self.set_level_hard)
	$VBoxContainer/SeriouslyDifficultyButton.pressed.connect(self.set_level_seriously)
	$VBoxContainer/HellDifficultyButton.pressed.connect(self.set_level_hell)
	
func set_level_normal() :
	get_parent().difficulty = get_parent().difficulty_enum.NORMAL

func set_level_hard() :
	get_parent().difficulty = get_parent().difficulty_enum.HARD

func set_level_seriously() :
	get_parent().difficulty = get_parent().difficulty_enum.SERIOUSLY

func set_level_hell() :
	get_parent().difficulty = get_parent().difficulty_enum.HELL

func quit_game() :
	print("Quit")
	get_parent().quit_game()
