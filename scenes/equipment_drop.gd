extends RigidBody2D

enum drop_type {HEALTH, TRIPLELASER, SHIP }
var type = drop_type.HEALTH

var speed = 50

func _ready():
	var is_created : bool = false
	self.linear_velocity = Vector2(0.0,50.0)
	add_to_group("EquipmentDrop")
	var rng_integer = randi() % 100
	if rng_integer < 20 :
		$AnimatedSprite2D.play("TripleLaser")
		type = drop_type.TRIPLELASER
		is_created = true
	elif rng_integer > 20 && rng_integer < 60 : 
		$AnimatedSprite2D.play("Heart")
		type = drop_type.HEALTH
		is_created = true
	elif rng_integer > 60 && rng_integer < 80 : 
		$AnimatedSprite2D.play("Ship")
		type = drop_type.SHIP
		is_created = true
	else : 
		queue_free()
	if is_created :
		$OnscreenTimer.start()


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_onscreen_timer_timeout():
	var tween = get_tree().create_tween()
	tween.tween_property($".", "scale",Vector2.ZERO,2.0)
	tween.connect("finished", on_tween_finished)

func on_tween_finished():
	#print("Tween done!")
	queue_free()

