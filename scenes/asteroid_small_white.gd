extends AsteroidBaseClass

func _ready():
	asteroid_size = Size.SMALL
	hit_points = 3
	screensize = get_viewport_rect().size
	hit_offset = -20
