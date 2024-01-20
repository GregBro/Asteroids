extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	var file = "res://data/LevelData.json"
	var json_as_text = FileAccess.get_file_as_string(file)
	var json_as_dict = JSON.parse_string(json_as_text)
	var firstLevel = json_as_dict[0]
	print(firstLevel)
	
