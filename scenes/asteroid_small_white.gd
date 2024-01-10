extends AsteroidParent

func _ready():
	asteroid_size = Size.SMALL
	hit_points = 2
	screensize = get_viewport_rect().size
	hit_offset = -10
