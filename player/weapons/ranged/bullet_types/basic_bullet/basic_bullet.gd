extends CharacterBody2D

#ONLY COLLISION MASK IS ON MAY CAUSE ISSUES IN THE FUTURE, I.E. ROCKETS TAKING DAMAGE

@export var bullet_type : bullet_class


func _ready():

	var bullet_spread_neg = -bullet_type.bullet_spread
	var new_bullet_direction = self.position + bullet_type.bullet_direction.rotated(randf_range(-bullet_type.bullet_spread , bullet_type.bullet_spread))
	
	look_at(new_bullet_direction)
	velocity = Vector2(bullet_type.bullet_speed, 0).rotated(self.rotation)




func _physics_process(delta):
	move_and_slide()

	#checks if collided body is in enemy group
	if get_last_slide_collision() != null && get_last_slide_collision().get_collider().is_in_group("enemy"):
		get_last_slide_collision().get_collider().get_node("damage_reciver").call("take_damage", bullet_type.damage)

#CHANGE to check for a pericing modifyer, and set up to hit an enemy once the put it in a stack, untill collisions stop
		queue_free()
