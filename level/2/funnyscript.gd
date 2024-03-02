extends Node2D

@onready var bad_guy = load("res://ememies/little_guy/little_guy.tscn")
var count : int

func _process(delta):

	if Input.is_action_just_pressed("debug"):
		var new_bad_guy = bad_guy.instantiate()
		new_bad_guy.position.x += randi_range(-150,150)
		new_bad_guy.position.y += randi_range(-100,100)
		$deadnode0.add_child(new_bad_guy)
		count += 1
	
	if Input.is_action_just_pressed("debug2"):
		for i in 5:
			var new_bad_guy = bad_guy.instantiate()
			new_bad_guy.position.x += randi_range(-150,150)
			new_bad_guy.position.y += randi_range(-100,100)
			$deadnode1.add_child(new_bad_guy)
			count += 1


	if Input.is_action_just_pressed("debug3"):
		for i in 50:
			var new_bad_guy = bad_guy.instantiate()
			new_bad_guy.position.x += randi_range(-150,150)
			new_bad_guy.position.y += randi_range(-100,100)
			$deadnode2.add_child(new_bad_guy)
			count += 1


















