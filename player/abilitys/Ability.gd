extends Node

var list_of_abilitys : Array
var active_ablility = false
var ability_ready = true

func _ready():
	for ability in get_children():
		list_of_abilitys.append(ability)

func Activate_Ability():
	ability_ready = false
	if list_of_abilitys.size() > 1:
		multi_activate()
	else:
		single_activate(list_of_abilitys[0])

func single_activate(ability):
	ability.call("activate")

func multi_activate():
	pass
	#for multiple abilty types abilites?


func _process(delta):
	#not set to check for multiple abilities, still not sure if we will need it
	if list_of_abilitys[0].activated == true:
		list_of_abilitys[0].call("update", delta)
