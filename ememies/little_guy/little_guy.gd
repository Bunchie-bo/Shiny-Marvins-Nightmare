extends CharacterBody2D


var temp_vel : Vector2
var can_move = true

@onready var spawner = $very_small_guy_spawner
@onready var small_guy = load("res://ememies/very_small_guy/very_small_guy.tscn")

func _process(delta):


	if velocity.x > 0:
		$AnimatedSprite2D.play("right")
	else:
		$AnimatedSprite2D.play("left")

	velocity = Vector2(20,0).rotated(get_angle_to(get_parent().get_parent().get_node("player").position))

	if can_move == true:
		move_and_slide()



func _on_very_small_guy_spawner_timeout():
	return
	for i in 3:
		var new_small_guy = small_guy.instantiate()
		new_small_guy.position.y = self.position.y + 2 
		add_child(new_small_guy)
