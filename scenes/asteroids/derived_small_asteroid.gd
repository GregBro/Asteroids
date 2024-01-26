extends AsteroidBaseClass

func _ready():
	asteroid_size = Globals.AsteroidSize.SMALL
	hit_points = 3
	hit_offset = -25
	screen_wrap_offset = 30
	mass = 100.0
