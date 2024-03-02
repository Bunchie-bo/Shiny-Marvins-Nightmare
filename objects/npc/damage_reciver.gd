extends Node2D



@export var HP : int


func take_damage(damage : int):
	if HP - damage > 0:
		HP -= damage
	elif get_parent():
		get_parent().queue_free()



