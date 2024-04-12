extends Area2D

@export var ranged_weapon : ranged_weapon_class

@export var meele_weapon : meele_weapon_class



func _ready():
	$Sprite2D.texture = load(ranged_weapon.image)

func pickup():
	if ranged_weapon:
		return ranged_weapon
	else: 
		return meele_weapon

func _on_body_entered(body):
	body.call("interact_list", self, true)
func _on_body_exited(body):
	body.call("interact_list", self, false)


func remove():
	queue_free()
