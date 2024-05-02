extends EnemyState
class_name EnemyFollow


func Enter():
	player = get_tree().get_first_node_in_group("Player")

func Physics_Update(delta: float):
	var dir = player.global_position - enemy.global_position

	if dir.length() > 25:
		enemy.velocity = dir.normalized() * move_speed
	else:
		enemy.velocity = Vector2()

	if dir.length() > 280:
		Transitioned.emit(self, "idle")

	if dir.length() < 50:
		enemy.velocity = Vector2.ZERO
		Transitioned.emit(self, "attack")
