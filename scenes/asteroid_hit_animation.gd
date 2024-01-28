extends AnimatedSprite2D

func _on_animation_finished():
	queue_free()


#func _on_ready():
	#$AudioStreamManager.play("res://Audio/CannonBoom.ogg")
