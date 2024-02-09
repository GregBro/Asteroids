extends CanvasLayer


func _ready() :
	$VBoxContainer/ResumeButton.pressed.connect(self.resume_game)
	$VBoxContainer/ExitButton.pressed.connect(self.quit_game)
	#$VBoxContainer/ResumeButton.grab_focus()


func resume_game() :
	print("Resumed")
	self.hide()
	get_tree().paused = false


func quit_game() :
	print("Quit")
	get_parent().quit_game()
