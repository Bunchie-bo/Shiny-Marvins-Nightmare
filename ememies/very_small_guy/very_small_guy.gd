extends CharacterBody2D


var temp_vel : Vector2
var can_move = true

func _process(delta):

	velocity = Vector2(20,0).rotated(get_angle_to(get_parent().get_parent().get_parent().get_node("player").position))

	if can_move == true:
		move_and_slide()


