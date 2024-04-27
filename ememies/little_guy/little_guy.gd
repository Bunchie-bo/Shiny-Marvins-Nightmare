extends CharacterBody2D

var accel = 50
var speed = 50
var temp_vel : Vector2
var can_move = true
var direction 

#problby needs to change, some of this was for testing spawing of little guys 
@onready var spawner = $very_small_guy_spawner
@onready var small_guy = load("res://ememies/very_small_guy/very_small_guy.tscn")
@onready var nav = $NavigationAgent2D


func _physics_process(delta):
	move_and_slide()

	if velocity.x > 0:
		$AnimatedSprite2D.play("right")
	else:
		$AnimatedSprite2D.play("left")








	'''
DEBUG STUFF!!!   DEBUG STUFF!!!   DEBUG STUFF!!!   DEBUG STUFF!!!   DEBUG STUFF!!!   DEBUG STUFF!!!   
	direction = nav.get_next_path_position() - global_position
	direction = direction.normalized()

	velocity = velocity.lerp(direction * speed, accel * delta)


	if can_move == true:
		move_and_slide()


func _on_very_small_guy_spawner_timeout():
	return
	for i in 3:
		var new_small_guy = small_guy.instantiate()
		new_small_guy.position.y = self.position.y + 2 
		add_child(new_small_guy)


func _on_nav_update_timeout():
	nav.target_position = get_parent().get_parent().get_node("player").position
	
	'''
