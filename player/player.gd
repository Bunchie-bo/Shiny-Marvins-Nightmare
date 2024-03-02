extends CharacterBody2D

@export var weapon : Resource

var in_game = true

var speed = 7500.0





func _ready():
	if in_game == true:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func _physics_process(delta):

	var horizontalInput = Input.get_axis("left", "right")
	var verticalInput = Input.get_axis("up", "down")
	var moveDirection = Vector2(horizontalInput, verticalInput)

	velocity = lerp(velocity, ( (moveDirection.normalized() * delta) * speed ) , 0.2)

	move_and_slide()





func _process(delta):

	"""Shooting is bias twards left and right and the other block is bias twards anything that
	is not the right direction, should fix to bias the most recently pressed key to avoid
	hang ups when changeing shooting direction"""



	var verticalShoot
	var horizontalShoot = Input.get_axis("shoot_left", "shoot_right")
	if ! horizontalShoot:
		verticalShoot = Input.get_axis("shoot_up", "shoot_down")
	else:
		verticalShoot = 0

	"""
	var shootDirection = Vector2(0,0)
	if Input.is_action_pressed("shoot_right"):
		shootDirection = Vector2(1,0)
	if Input.is_action_pressed("shoot_left"):
		shootDirection = Vector2(-1,0)
	if Input.is_action_pressed("shoot_down"):
		shootDirection = Vector2(0,1)
	if Input.is_action_pressed("shoot_up"):
		shootDirection = Vector2(0,-1)
	"""

	var shootDirection = Vector2(horizontalShoot, verticalShoot)

	$RayCast2D.target_position = Vector2(shootDirection.x, shootDirection.y)


	global.player_pos = self.position

	if Input.is_action_pressed("shoot_down") || Input.is_action_pressed("shoot_up") || Input.is_action_pressed("shoot_right") || Input.is_action_pressed("shoot_left"):
		primary_attack()



func primary_attack():
	if weapon != null && weapon.cool_down == true:
		weapon.aim_dir = $RayCast2D.target_position
		
		for i in weapon.bullet_count:
			get_parent().add_child(weapon.call("attack"))
		
		$Timer.wait_time = weapon.fire_rate
		$Timer.start()
		weapon.cool_down = false


#TODO
func roll():
	pass

func ability():
	pass

func use_item():
	pass





func _on_timer_timeout():
	weapon.call("cool_down_timeout")
	$Timer.stop()
