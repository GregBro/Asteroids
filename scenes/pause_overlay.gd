extends CanvasLayer

var show_msg : bool = false

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
	if get_parent().get_node("UI").get_node("MsgLabel").is_visible() :
		get_parent().get_node("UI").get_node("MsgLabel").hide()
		show_msg = true
	else :
		show_msg = false
	self.show()
	$VBoxContainer/ResumeButton.grab_focus()

func resume_game() :
	print("Resumed")
	if show_msg :
		get_parent().get_node("UI").get_node("MsgLabel").show()
		show_msg = false
	self.hide()
	get_tree().paused = false


func quit_game() :
	print("Quit")
	get_parent().quit_game()
