extends Area2D

var speed = 300
var speed_x = 200
var speed_y = 200
var direction: Vector2 = Vector2.UP

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += direction * speed * delta

	

func _on_body_entered(body):
	if body.is_in_group("Asteroids") :
		queue_free()
		body.hit(position,direction)
	


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


