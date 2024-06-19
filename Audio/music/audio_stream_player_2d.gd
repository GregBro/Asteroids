extends AudioStreamPlayer2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MsgQueue.connect("start_music", start_music)
	MsgQueue.connect("stop_music", stop_music)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func start_music() :
	print("Got to Start Music")
	play()

func stop_music() :
	stop()
