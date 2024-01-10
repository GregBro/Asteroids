extends RigidBody2D

class_name AsteroidParent

enum States {SHOULD_TRANSLATE, JUST_TRANSLATED, MOVING}
var asteroid_state = States.MOVING

var speed_x = -100
var speed_y = -100
var rotation_speed = 1
#var view_size = get_viewport_rect().size
var screensize 
var has_left_the_viewport : bool = false
var was_in_the_viewport : bool = false

var hit_points : int = 5


func hit() :
	hit_points -= 1
	if hit_points <= 0 :
		break_apart()

func break_apart():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	screensize = get_viewport_rect().size
	#print("screensize :" + str(screensize))
	set_angular_velocity(rotation_speed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#position.x += speed_x * delta
	#position.y += speed_y * delta
	#rotation_degrees +=  rotation_speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	#print("Base Class Screen Exited")
	#print("Initial position " + str(position))
	#print("Viewport : " + str(screensize))
	if asteroid_state == States.MOVING :
		asteroid_state = States.SHOULD_TRANSLATE

func _on_visible_on_screen_notifier_2d_screen_entered():
	asteroid_state = States.MOVING

func _integrate_forces(state):
	var xform = state.get_transform()
	
	#print("Viewport : " + str(screensize))
	#print("xform : " + str(xform.origin))
	#print("Position : " + str(position))
	#print(str(asteroid_state))
	#set_axis_velocity(linear_velocity) 
	if asteroid_state == States.SHOULD_TRANSLATE :
		#print("In Translate Code")
		if xform.origin.x > screensize.x:
			#print("resetting x ")
			xform.origin.x = 0
			asteroid_state = States.JUST_TRANSLATED
			state.set_transform(xform)
			#print("xform : " + str(xform.origin))
			
		if xform.origin.x < 0:
			#print("resetting x ")
			xform.origin.x = screensize.x 
			asteroid_state = States.JUST_TRANSLATED
			#print("xform : " + str(xform.origin))
			
		if xform.origin.y > screensize.y:
			#print("resetting y ")
			xform.origin.y = 0
			asteroid_state = States.JUST_TRANSLATED
			#print("xform : " + str(xform.origin))

		if xform.origin.y < 0:
			#print("resetting y ")
			xform.origin.y = screensize.y
			asteroid_state = States.JUST_TRANSLATED
			#print("xform : " + str(xform.origin))
		state.set_transform(xform)
	
	##set_applied_force(thrust.rotated(rotation))
	##set_applied_torque(rotation_dir * spin_thrust)
