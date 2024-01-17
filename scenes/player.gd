extends RigidBody2D

var laser_scene : PackedScene = preload("res://scenes/laser.tscn")
var explosion_scene : PackedScene = preload("res://scenes/explosion_1.tscn")

signal next_level
enum States {PLAYING, HIDING}
var shipStatus = States.PLAYING

var can_laser : bool = true
var screensize 
var rotation_speed = 2
var thrust_speed = 100

var hit_points : int = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	screensize = get_viewport_rect().size
	shipStatus = States.PLAYING
	hit_points = 2
	position = Vector2(screensize.x/2, screensize.y/2)
	add_to_group("Player")
	show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("right") :
		if angular_velocity < 2 :
			angular_velocity += rotation_speed * delta
			$RotateClockwiseRearJet.show()
			$RotateClockwiseFrontJet.show()
	if Input.is_action_just_released("right")	:		
		$RotateClockwiseRearJet.hide()
		$RotateClockwiseFrontJet.hide()
	
	if Input.is_action_pressed("left") :
		if angular_velocity >-2 :
			angular_velocity -= rotation_speed * delta
			$RotateCounterClockFrontJet.show()
			$RotateCounterClockRearJet.show()
	if Input.is_action_just_released("left")	:		
		$RotateCounterClockFrontJet.hide()
		$RotateCounterClockRearJet.hide()
	
	if Input.is_action_pressed("forward") :
		if linear_velocity.length() < 100 :
			apply_central_impulse(Vector2(cos(rotation), sin(rotation)) * thrust_speed * delta)
			$ThrustJetLeft.show()
			$ThrustJetRight.show()
	if Input.is_action_just_released("forward")	:
		$ThrustJetLeft.hide()
		$ThrustJetRight.hide()
	
	if Input.is_action_pressed("reverse") :
		if linear_velocity.length() < 100 :
			apply_central_impulse(Vector2(cos(rotation), sin(rotation)) * thrust_speed * delta * -1)
			$ReverseJetLeft.show()
			$ReverseJetRight.show()
	if Input.is_action_just_released("reverse")	:
		$ReverseJetLeft.hide()
		$ReverseJetRight.hide()		

	if Input.is_action_pressed("fire_laser") && can_laser && is_visible_in_tree() :
		#print("Fire!")
		$LaserTimer.start()
		can_laser = false
		var player_pos = position
		var player_direction = rotation
		fire_laser(player_pos, player_direction )
		

func fire_laser(player_pos, player_direction ) :
	print("Asteroids left : " + str(get_tree().get_nodes_in_group("Asteroids").size()) )
	var laser = laser_scene.instantiate()
	laser.rotation_degrees = rad_to_deg(player_direction) 
	laser.direction = Vector2.RIGHT.rotated(player_direction)
	laser.position = player_pos + (laser.direction * 50)
	laser.add_to_group("Lasers")
	$"..".add_child(laser)
	
func _on_body_entered(body):
	if(body.is_in_group("Asteroids")) :
		hit_points -= 1
		if hit_points <= 0 :
			lose_ship()
	
func lose_ship() :
	shipStatus = States.HIDING
	var last_position = position
	position.x = -200
	hide()
	Globals.ships -= 1
	var explosion =  explosion_scene.instantiate()
	explosion.position = last_position
	get_parent().call_deferred("add_child",explosion)
	var explosion_node = explosion.get_node("AnimatedSprite2D")
	explosion_node.play("explosion1")
	explosion_node.animation_finished.connect(cleanup_ship)
	get_parent().call_deferred("queue_free",explosion)

func cleanup_ship():
	$RespawnTimer.start()
	$"../UserInterface/MessageLabel".text = "Ready"
	$"../UserInterface/MessageLabel".show()

	
func _integrate_forces(state):
	
	var xform = state.get_transform()
	if xform.origin.x > screensize.x:
		xform.origin.x = 0
		state.set_transform(xform)
		
	if xform.origin.x < 0:
		xform.origin.x = screensize.x 
		
	if xform.origin.y > screensize.y:
		xform.origin.y = 0

	if xform.origin.y < 0:
		xform.origin.y = screensize.y 

	state.set_transform(xform)
	var asteroids_left = get_tree().get_nodes_in_group("Asteroids").size()
	if asteroids_left == 1 :
		next_level.emit()
	

func _on_laser_timer_timeout():
	can_laser = true


func _on_respawn_timer_timeout():
	global_position.x = screensize.x /2
	global_position.y = screensize.y /2
	linear_velocity = Vector2.ZERO
	angular_velocity = 0
	hit_points = 3
	$"../UserInterface/MessageLabel".hide()
	show()
	
