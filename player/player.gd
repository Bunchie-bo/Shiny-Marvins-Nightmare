extends CharacterBody2D

#Weapon vars
@export var equiped_weapon : weapon_class
var weapon_list = []
var selected_weapon = 0

#interact
var interactable_list = []

#Movement vars
var speed = 8500.0

var can_move = true
var stuned = false

#Game vars
var in_game = true
var defualt_character_stats = "res://player/defualt_character_stats.json"
var new_run = true
var character_sheet : Dictionary
var max_health : int
var current_health : int
var normal_items = []
var weird_items = []

func _ready():
	if in_game == true:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	if equiped_weapon:
		weapon_list.append(equiped_weapon)
	if new_run:
		create_character_sheet()
	else:
		calculate_new_values()


func create_character_sheet():
	var file = FileAccess.open(defualt_character_stats, FileAccess.READ)
	var text = file.get_as_text()
	character_sheet = JSON.parse_string(text)
	$Camera2D/CanvasLayer/ui/MarginContainer/HBoxContainer/VBoxContainer2/HealthBar.max_value = max_health

func calculate_new_values():
	#Fine for now but speed needs to be equal to a base speed times the character sheet,
	#this will multiply speed exponatialy with each speed related item
	speed *= character_sheet.get("move_speed")
	max_health = character_sheet.get("max_health")
	
	$Camera2D/CanvasLayer/ui/MarginContainer/HBoxContainer/VBoxContainer2/HealthBar.max_value = max_health
	print(max_health)


	if new_run:
		current_health = max_health

func update_items(items: Dictionary):
	for i in items:
		if i == "normal_items":
			normal_items = items[i]
		else:
			weird_items = items[i]

	for i in normal_items:
		for mod in i.modifiers:
			for type in mod:
				character_sheet[type] += mod[type]
	calculate_new_values()


func _physics_process(delta):

	var horizontalInput = Input.get_axis("left", "right")
	var verticalInput = Input.get_axis("up", "down")
	var move_direction = Vector2(horizontalInput, verticalInput)


	if can_move:
		velocity = lerp(velocity, ( (move_direction.normalized() * delta) * speed ) , 0.2)

	if Input.is_action_just_pressed("ability") && $Ability.ability_ready == true:
		$Ability.call("Activate_Ability")

	move_and_slide()


func _process(delta):

	if interactable_list != []:
		$ToolTips/VBoxContainer/Name.set_text(interactable_list[0].ranged_weapon.name)
		$ToolTips/VBoxContainer/Stats.set_text("Damage: " + str(interactable_list[0].ranged_weapon.damage) + "\nFire rate: " + str(interactable_list[0].ranged_weapon.fire_rate))
	else:
		$ToolTips/VBoxContainer/Name.set_text("")
		$ToolTips/VBoxContainer/Stats.set_text("")

#DEBUG!!   DEBUG!!   DEBUG!!   DEBUG!!   DEBUG!!   DEBUG!!   
	#$debug_lable.set_text(str(equiped_weapon.heat))
#DEBUG!!   DEBUG!!   DEBUG!!   DEBUG!!   DEBUG!!   DEBUG!!
# not sure where to put this either, updates global for player, used for enemies
	global.player_pos = self.position

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

	if Input.is_action_pressed("shoot_down") || Input.is_action_pressed("shoot_up") || Input.is_action_pressed("shoot_right") || Input.is_action_pressed("shoot_left"):
		primary_attack()
	if $heat_cooling.is_stopped() && equiped_weapon.heat != 0 && $fire_rate.is_stopped() == false:
		$heat_cooling.start()

	if Input.is_action_just_pressed("interact"):
		pickup()

		#weapon switch
	if Input.is_action_just_pressed("next_weapon") && weapon_list.size() > 1:
		if selected_weapon < weapon_list.size() - 1:
			selected_weapon += 1
		else:
			selected_weapon = 0
		equiped_weapon = weapon_list[selected_weapon]
	elif weapon_list != []:
		equiped_weapon = weapon_list[selected_weapon]

func pickup():
	if interactable_list != []:
		if ! weapon_list.has(interactable_list[0].call("pickup")):
			weapon_list.append(interactable_list[0].call("pickup"))
			interactable_list[0].call("remove")
		else:
			interactable_list[0].call("remove")

func interact_list(node, add : bool):
	if add:
		interactable_list.append(node)
	else:
		interactable_list.erase(node)

func primary_attack():
	if equiped_weapon != null && equiped_weapon.cool_down == true:
		equiped_weapon.aim_dir = $RayCast2D.target_position

		for i in equiped_weapon.bullet_count:
			get_parent().add_child(equiped_weapon.call("attack"))

		if equiped_weapon.heat + equiped_weapon.heat_up > equiped_weapon.max_heat:
			equiped_weapon.heat = equiped_weapon.max_heat
		else:
			equiped_weapon.heat += equiped_weapon.heat_up

		$fire_rate.wait_time = equiped_weapon.fire_rate * character_sheet.get("attack_speed")
		$fire_rate.start()
		equiped_weapon.cool_down = false



func take_damage(damage : int):
	if current_health - damage < 0:
		die()
	else:
		current_health -= damage
		$Camera2D/CanvasLayer/ui/MarginContainer/HBoxContainer/VBoxContainer2/HealthBar.value = current_health

func die():
	pass
	#player dies : D


#TODO
func ability():
	pass

func use_item():
	pass



func _on_timer_timeout():
	equiped_weapon.call("cool_down_timeout")
	$fire_rate.stop()

func _on_heat_cooling_timeout():
	if equiped_weapon.heat - equiped_weapon.cooling_rate <= 0:
		equiped_weapon.heat = 0
		$heat_cooling.stop()
	else:
		equiped_weapon.heat -= equiped_weapon.cooling_rate
		$heat_cooling.start()
