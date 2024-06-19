extends Area2D

var speed = 300
var direction: Vector2 = Vector2.UP

func _process(delta):
	position += direction * speed * delta


func _on_body_entered(body):
	if body.is_in_group("Asteroids") :
		queue_free()
		body.hit(position)


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
