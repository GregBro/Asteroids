extends AnimatedSprite2D


func _on_animation_finished():
	queue_free()
	
func _on_animated_sprite_2d_animation_finished():
	queue_free()
