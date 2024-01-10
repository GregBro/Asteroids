extends RigidBody2D

class_name AsteroidParent

#enum States {SHOULD_TRANSLATE, JUST_TRANSLATED, MOVING}
enum Size {LARGE,MEDIUM,SMALL}

var asteroid_hit_scene : PackedScene = preload("res://scenes/small_explosion.tscn")

#var asteroid_large_scene : PackedScene = preload("res://scenes/asteroid_large_white.tscn")
#var asteroid_medium_scene : PackedScene = preload("res://scenes/asteroid_medium_white.tscn")
#var asteroid_small_scene : PackedScene = preload("res://scenes/asteroid_small_white.tscn")

var asteroid_size = Size.LARGE

var speed_x = -100
var speed_y = -100
var rotation_speed = 1

var screensize 

var hit_points : int = 5
var hit_offset = -50

func hit(_laser_position, laser_direction) :
	hit_points -= 1
	Globals.update_score(1)
	var asteroid_hit = asteroid_hit_scene.instantiate()
	asteroid_hit.position =  (laser_direction.normalized() * hit_offset) 
	add_child(asteroid_hit)
	asteroid_hit.play("hit")
	if hit_points <= 0 :
		if asteroid_size != Size.SMALL :
			break_apart()
		else :
			queue_free()

func break_apart():
	var asteroid_1
	var asteroid_2
	
	if asteroid_size == Size.LARGE :
		asteroid_1 = Globals.build_medium_asteroid()
		asteroid_2 = Globals.build_medium_asteroid()
	else :
		asteroid_1 = Globals.build_small_asteroid()
		asteroid_2 = Globals.build_small_asteroid()
	
	asteroid_1.position = position	- Vector2(25,25)
	asteroid_2.position = position	+ Vector2(25,25)	
	asteroid_1.linear_velocity = linear_velocity.rotated(-0.25) 
	asteroid_2.linear_velocity = linear_velocity.rotated(0.25) 

	asteroid_1.add_to_group("Asteroids")
	asteroid_2.add_to_group("Asteroids")
	
	get_parent().call_deferred("add_child", asteroid_1)
	get_parent().call_deferred("add_child", asteroid_2)
	queue_free()


# Called when the node enters the scene tree for the first time.
func _ready():
	screensize = get_viewport_rect().size
	set_angular_velocity(rotation_speed)
	asteroid_size = Size.LARGE
	#print(get_parent().name)


func _integrate_forces(state):
	var xform = state.get_transform()
	
	#print("Viewport : " + str(screensize))
	#print("xform : " + str(xform.origin))
	#print("Position : " + str(position))
	#print(str(asteroid_state))
	#set_axis_velocity(linear_velocity) 
	if xform.origin.x > screensize.x + 70:
		#print("resetting x ")
		xform.origin.x = -70
		
	if xform.origin.x < -70:
		#print("resetting x ")
		xform.origin.x = screensize.x + 70
		
	if xform.origin.y > screensize.y + 70:
		#print("resetting y ")
		xform.origin.y = -70

	if xform.origin.y < -70:
		#print("resetting y ")
		xform.origin.y = screensize.y + 70

	state.set_transform(xform)
	
	##set_applied_force(thrust.rotated(rotation))
	##set_applied_torque(rotation_dir * spin_thrust)
