extends Ability

@export var roll_speed : float
@export var roll_cooldown : float
@export var roll_exaust_time : float

var roll_exaust

func activate():

	player.get_node("Camera2D/CanvasLayer/ui/MarginContainer/HBoxContainer/VBoxContainer/ProgressBar").value = 0
	activated = true
	player.can_move = false
	player.velocity = lerp(player.velocity,(player.velocity.normalized()  * roll_speed), 1)

	var roll_time = Timer.new()
	roll_time.one_shot = true
	roll_time.timeout.connect(_on_roll_time_timeout)
	roll_time.set_wait_time(roll_cooldown)
	add_child(roll_time)
	roll_time.start()

func _on_roll_time_timeout():
	player.can_move = true

	roll_exaust = Timer.new()
	roll_exaust.one_shot = true
	roll_exaust.timeout.connect(_on_roll_exaust_timeout)
	roll_exaust.set_wait_time(roll_exaust_time)
	add_child(roll_exaust)
	roll_exaust.start()

func _on_roll_exaust_timeout():
	get_parent().ability_ready = true
	activated = false

func update(delta):
	if roll_exaust:
		player.get_node("Camera2D/CanvasLayer/ui/MarginContainer/HBoxContainer/VBoxContainer/ProgressBar").value = (1 - roll_exaust.time_left) * 100

