extends AsteroidBaseClass

func _ready():
	asteroid_size = Size.LARGE
	hit_points = 5
	screensize = get_viewport_rect().size
	hit_offset = -50



