extends RigidBody2D

var can_laser : bool = true
var can_crash : bool = true
var triple_laser_enabled : bool = false
var screensize 
var rotation_speed = 2
var thrust_speed = 150
var max_velocity = 250
var max_rotation = 2


func _ready():
	screensize = get_viewport_rect().size
	Globals.ship_health = Globals.ship_health_initial_value
	#Globals.ships = Globals.ships_starting_amount
	$RotateClockwiseRearJet.play()
	$RotateClockwiseFrontJet.play()
	$RotateCounterClockFrontJet.play()
	$RotateCounterClockRearJet.play()
	$ThrustJetLeft.play()
	$ThrustJetRight.play()
	$ReverseJetLeft.play()
	$ReverseJetRight.play()


func _process(delta):
	if Input.is_action_pressed("right") :
		if angular_velocity < max_rotation :
			angular_velocity += rotation_speed * delta
			$RotateClockwiseRearJet.show()
			$RotateClockwiseFrontJet.show()
	if Input.is_action_just_released("right")	:		
		$RotateClockwiseRearJet.hide()
		$RotateClockwiseFrontJet.hide()
	
	if Input.is_action_pressed("left") :
		if angular_velocity > (max_rotation * -1) :
			angular_velocity -= rotation_speed * delta
			$RotateCounterClockFrontJet.show()
			$RotateCounterClockRearJet.show()
	if Input.is_action_just_released("left")	:		
		$RotateCounterClockFrontJet.hide()
		$RotateCounterClockRearJet.hide()
	
	if Input.is_action_pressed("forward") :
		apply_central_impulse(Vector2(cos(rotation), sin(rotation)) * thrust_speed * delta)
		$ThrustJetLeft.show()
		$ThrustJetRight.show()
		limit_max_velocity()
	if Input.is_action_just_released("forward")	:
		$ThrustJetLeft.hide()
		$ThrustJetRight.hide()
	
	if Input.is_action_pressed("reverse") :
		apply_central_impulse(Vector2(cos(rotation), sin(rotation)) * thrust_speed * delta * -1)
		$ReverseJetLeft.show()
		$ReverseJetRight.show()
		limit_max_velocity()
	if Input.is_action_just_released("reverse")	:
		$ReverseJetLeft.hide()
		$ReverseJetRight.hide()			
	if Input.is_action_pressed("fire_laser") && can_laser && is_visible_in_tree() :
		#print("Fire!")
		$LaserTimer.start()
		can_laser = false
		if(Globals.weapon_heat >= Globals.weapon_heat_max_value) :
			Globals.ship_health -= 1
			return
		Globals.weapon_heat += 2
		var player_pos = position
		var player_direction = rotation
		MsgQueue.send_fire_laser(player_pos, player_direction )
		if triple_laser_enabled :
			MsgQueue.send_fire_laser(player_pos, player_direction + PI/30 )
			MsgQueue.send_fire_laser(player_pos, player_direction - PI/30 )


func _integrate_forces(state):
	var xform = state.get_transform()
	
	if xform.origin.x > screensize.x:
		xform.origin.x = 0
		
	if xform.origin.x < 0:
		xform.origin.x = screensize.x 
		
	if xform.origin.y > screensize.y:
		xform.origin.y = 0
		
	if xform.origin.y < 0:
		xform.origin.y = screensize.y 
	state.set_transform(xform)


func _on_laser_timer_timeout():
	can_laser = true
	#$LaserTimer.stop()


func _on_body_entered(body):
	if can_crash && body.is_in_group("Asteroids"):
		#Logger.debug("Ships " + str(Globals.ships))
		can_crash = false
		Globals.ship_health -= 10
		#Logger.debug("Health : " + str(Globals.ship_health))
		MsgQueue.send_asteroid_hit(position)
		if Globals.ship_health <= 0 :
			lose_ship()
		else :
			$CrashTimer.start()
		limit_max_velocity()
	if body.is_in_group("EquipmentDrop"):
		handle_equip_drop(body)


func handle_equip_drop(body):
	var type = body.type
	print ("Caught Equipment Drop")
	if type == body.drop_type.HEALTH :
		Globals.ship_health +=30
	if type == body.drop_type.SHIP :
		Globals.ships +=1
	if type == body.drop_type.TRIPLELASER :
		start_triple_laser()
	body.queue_free()


func start_triple_laser() :
	triple_laser_enabled = true
	$TripleLaserTimer.start()
	
	
func _on_crash_timer_timeout():
	can_crash = true


func lose_ship() :
	#print("In Lose Ships " + str(Globals.ships))
	Globals.ships = Globals.ships -1
	queue_free()
	MsgQueue.send_lose_ship()


func limit_max_velocity() :
	if linear_velocity.x > max_velocity :
		linear_velocity.x = max_velocity 
	if linear_velocity.y > max_velocity :
		linear_velocity.y = max_velocity 


func _on_triple_laser_timer_timeout():
	triple_laser_enabled = false
