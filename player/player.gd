extends CharacterBody2D

#Weapon vars
@export var equiped_weapon : Resource
var weapon_list = []
var selected_weapon = 0

#Movement vars
var speed = 7500.0
var roll_speed = 300.0
var can_move = true
var can_roll = true
var stuned = false

#Game vars
var in_game = true


func _ready():
	if in_game == true:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	if equiped_weapon:
		weapon_list.append(equiped_weapon)


func _physics_process(delta):

	var horizontalInput = Input.get_axis("left", "right")
	var verticalInput = Input.get_axis("up", "down")
	var move_direction = Vector2(horizontalInput, verticalInput)

	if can_move:
		velocity = lerp(velocity, ( (move_direction.normalized() * delta) * speed ) , 0.2)

	if Input.is_action_just_pressed("roll") && can_roll:
		roll(move_direction)

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

		#weapon switch
	if Input.is_action_just_pressed("next_weapon") && weapon_list.size() > 1:
		if selected_weapon < weapon_list.size() - 1:
			selected_weapon += 1
		else:
			selected_weapon = 0
		equiped_weapon = weapon_list[selected_weapon]




func primary_attack():
	if equiped_weapon != null && equiped_weapon.cool_down == true:
		equiped_weapon.aim_dir = $RayCast2D.target_position
		
		for i in equiped_weapon.bullet_count:
			get_parent().add_child(equiped_weapon.call("attack"))
		
		$Timer.wait_time = equiped_weapon.fire_rate
		$Timer.start()
		equiped_weapon.cool_down = false


func roll(move_direction):
	can_move = false
	can_roll = false
	#DISSABLE ENEMY ATTACK COLLISION HERE
	velocity = lerp(velocity,(move_direction.normalized()  * roll_speed), 1)
	$roll_time.start()
	$roll_exaust.start()

#TODO
func ability():
	pass

func use_item():
	pass

func _on_timer_timeout():
	equiped_weapon.call("cool_down_timeout")
	$Timer.stop()

func _on_roll_time_timeout():
	can_move = true

func _on_roll_exaust_timeout():
	can_roll = true
