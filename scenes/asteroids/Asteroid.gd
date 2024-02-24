extends RigidBody2D

class_name AsteroidBaseClass

var equipment_drop_scene : PackedScene = preload("res://scenes/equipment_drop.tscn")

var asteroid_size = Globals.AsteroidSize.LARGE

#var speed_x = -100
#var speed_y = -100
var rotation_speed = 2.5 + randf()

var screensize 

var hit_points : int = 5
var hit_offset = -50

var screen_wrap_offset = 70


func _ready():
	screensize = get_viewport_rect().size

#Causes the asteroid to wrap around as it goes offscreen
func _integrate_forces(state):
	var xform = state.get_transform()
	screensize = get_viewport_rect().size
	if xform.origin.x > screensize.x + screen_wrap_offset:
		xform.origin.x = -screen_wrap_offset
		
	if xform.origin.x < -screen_wrap_offset:
		xform.origin.x = screensize.x + screen_wrap_offset
		
	if xform.origin.y > screensize.y + screen_wrap_offset:
		xform.origin.y = -screen_wrap_offset

	if xform.origin.y < -screen_wrap_offset:
		xform.origin.y = screensize.y + screen_wrap_offset

	state.set_transform(xform)


func hit(laser_position) :
	#print("Asteroid_hit in Asteroid Node ")
	#print("asteroid_size " + str(asteroid_size))	
	hit_points -= 1
	#print("hit_points " + str(hit_points))
	Globals.score =  Globals.score + 10 
	#var hit_position = laser_position #+ (laser_direction.normalized() * hit_offset) 
	MsgQueue.send_asteroid_hit(laser_position)
	if hit_points <=0 : 
		if asteroid_size != Globals.AsteroidSize.SMALL :
			var this_position = position
			var this_velocity = linear_velocity
			var this_size = asteroid_size
			remove_from_group("Asteroids")
			queue_free()
			MsgQueue.send_asteroid_breakup( this_position, this_velocity, this_size)
		else  :
			if randi()%100 < 90 :
				var equip_drop = equipment_drop_scene.instantiate()
				equip_drop.position = laser_position
				get_parent().call_deferred("add_child",equip_drop)
			remove_from_group("Asteroids")
			call_deferred("queue_free")
		
		if asteroid_size == Globals.AsteroidSize.SMALL :
			var asteroids = get_tree().get_nodes_in_group("Asteroids")
			Logger.debug("In Asteroid Hit Asteroid count : " + str(asteroids.size()))
			if asteroids.size() <=0 : 
				var level_data = Globals.level_data
				Logger.debug ("Current level is " + str(level_data)) 
				var isLastLevel = level_data.IsLastLevel
				Logger.debug("is last level : " + str(isLastLevel))
				MsgQueue.send_score_change(1000)
				if isLastLevel == false :
					Globals.level += 1
				else :
					MsgQueue.send_rebuild_asteroids()

