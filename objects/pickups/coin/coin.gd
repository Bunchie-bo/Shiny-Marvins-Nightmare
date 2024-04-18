extends Area2D


'''look into particle effects to make a coin jump up and float over to the player like in 
vampire survivors or something :D'''




func _on_body_entered(body):
	if body == get_parent().get_node("player"):
		pass
