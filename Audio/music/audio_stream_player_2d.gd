extends AudioStreamPlayer2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MsgQueue.connect("start_music", start_music)
	MsgQueue.connect("stop_music", stop_music)

func start_music() :
	print("Got to Start Music")
	play()

func stop_music() :
	stop()
