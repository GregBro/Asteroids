extends AsteroidBaseClass

func _ready():
	print("Got to _ready()")
	asteroid_size = Size.LARGE
	hit_points = 5
	hit_offset = -50
	mass = 3000.0
