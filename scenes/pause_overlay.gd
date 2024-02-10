extends CanvasLayer


func _ready() :
	$VBoxContainer/ResumeButton.pressed.connect(self.resume_game)
	$VBoxContainer/ExitButton.pressed.connect(self.quit_game)
	#$VBoxContainer/ResumeButton.grab_focus()


	
func _process(_delta):
	if ( Input.is_action_pressed("ui_select")) :
		if $VBoxContainer/ResumeButton.has_focus() :
			resume_game()
		if $VBoxContainer/ExitButton.has_focus() :
			quit_game()


func enable() :
	get_tree().paused = true
	self.show()
	$VBoxContainer/ResumeButton.grab_focus()

func resume_game() :
	print("Resumed")
	self.hide()
	get_tree().paused = false


func quit_game() :
	print("Quit")
	get_parent().quit_game()
