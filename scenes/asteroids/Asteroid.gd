extends RigidBody2D

class_name AsteroidBaseClass

var asteroid_size = Globals.AsteroidSize.LARGE

#var speed_x = -100
#var speed_y = -100
var rotation_speed = 2.5 + randf()

var screensize 

var hit_points : int = 5
var hit_offset = -50

var screen_wrap_offset = 70

func _ready():
	#print("Parent")
	screensize = get_viewport_rect().size
	

func _integrate_forces(state):
	var xform = state.get_transform()
	screensize = get_viewport_rect().size
	#print("Viewport : " + str(screensize))
	#print("xform : " + str(xform.origin))
	#print("Position : " + str(position))
	#print(str(asteroid_state))
	#set_axis_velocity(linear_velocity) 
	if xform.origin.x > screensize.x + screen_wrap_offset:
		#print("resetting x ")
		xform.origin.x = -screen_wrap_offset
		
	if xform.origin.x < -screen_wrap_offset:
		#print("resetting x ")
		xform.origin.x = screensize.x + screen_wrap_offset
		
	if xform.origin.y > screensize.y + screen_wrap_offset:
		#print("resetting y ")
		xform.origin.y = -screen_wrap_offset

	if xform.origin.y < -screen_wrap_offset:
		#print("resetting y ")
		xform.origin.y = screensize.y + screen_wrap_offset

	state.set_transform(xform)
	
func hit(laser_position) :
	#print("Asteroid_hit in Asteroid Node ")
	#print("asteroid_size " + str(asteroid_size))	
	hit_points -= 1
	#print("hit_points " + str(hit_points))
	Globals.score =  Globals.score + 10 
	var hit_position = laser_position #+ (laser_direction.normalized() * hit_offset) 
	MsgQueue.send_asteroid_hit(hit_position)
	if hit_points <=0 : 
		if asteroid_size != Globals.AsteroidSize.SMALL :
			MsgQueue.send_asteroid_breakup( position, linear_velocity, asteroid_size)
		remove_from_group("Asteroids")
		queue_free()
		var asteroids = get_tree().get_nodes_in_group("Asteroids")
		print("In Asteroid Hit Asteroid count : " + str(asteroids.size()))
		if asteroids.size() <=2 : 
			pass
			#if check_for_lost_asteroids() == false :
				#print("No More Asteroids")
				#MsgQueue.send_score_change(1000)
				#MsgQueue.send_rebuild_asteroids()
				#Globals.level += 1
			
