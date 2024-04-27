extends EnemyState
class_name EnemyIdle


var move_dir : Vector2
var wander_time : float

func randomize_wander():
	move_dir = Vector2(randf_range(-1,1), randf_range(-1,1)).normalized()
	wander_time = randf_range(1,3)

func Enter():
	player = get_tree().get_first_node_in_group("Player")
	randomize_wander()

func Update(delta: float):
	if wander_time > 0:
		wander_time -= delta
	
	else:
		randomize_wander()

func Physics_Update(delta: float):
	if enemy:
		enemy.velocity =  move_dir * move_speed

	var dir = player.global_position - enemy.global_position
	if dir.length() < 150:
		Transitioned.emit(self, "follow")

