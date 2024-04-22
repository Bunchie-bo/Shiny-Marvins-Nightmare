extends CharacterBody2D

#ONLY COLLISION MASK IS ON MAY CAUSE ISSUES IN THE FUTURE, I.E. ROCKETS TAKING DAMAGE


var bullet_speed : float
var bullet_direction : Vector2
var damage : int
var bullet_spread : float


func _ready():

	var bullet_spread_neg = -bullet_spread
	var new_bullet_direction = self.position + bullet_direction.rotated(randf_range(-bullet_spread , bullet_spread))
	
	look_at(new_bullet_direction)
	velocity = Vector2(bullet_speed, 0).rotated(self.rotation)




func _physics_process(delta):
	move_and_slide()

	#checks if collided body is in enemy group
	if get_last_slide_collision() != null && get_last_slide_collision().get_collider().is_in_group("enemy"):
		get_last_slide_collision().get_collider().get_node("damage_reciver").call("take_damage", damage)

#CHANGE to check for a pericing modifyer, and set up to hit an enemy once the put it in a stack, untill collisions stop
		queue_free()
