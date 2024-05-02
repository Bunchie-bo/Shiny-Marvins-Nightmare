extends EnemyState
class_name EnemyMeeleAttack

var dir
var attack_time

func Enter():
	player = get_tree().get_first_node_in_group("Player")
	attack()

func Physics_Update(delta: float):
	dir = player.global_position - enemy.global_position

func attack():
	#NOT SURE IF THIS WILL CAUSE ISSUES, attack_time is being removed as a child but may be held in memory
	#and may cause lag issues down the line after lots of attacks
	attack_time = Timer.new()
	attack_time.timeout.connect(_on_timer_timeout)
	attack_time.set_wait_time(0.8)
	add_child(attack_time)
	attack_time.start()
	enemy.get_node("AnimatedSprite2D").play("attack")

func _on_timer_timeout():
	remove_child(attack_time)
	if dir.length() > 50:
		Transitioned.emit(self, "follow")
	else:
		attack()
