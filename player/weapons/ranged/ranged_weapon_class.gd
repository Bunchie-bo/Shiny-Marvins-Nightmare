extends Resource
class_name ranged_weapon_class

var aim_dir
var cool_down = true

@export_category("Weapon Stats")
@export var damage : int
@export var fire_rate : float

@export var reload_speed : float
@export var mag_size : int
@export var ammo_type : String
@export var bullet_count : int
@export var bullet_spread : float

@export_category("Bullet Stats")
@export var bullet_type : PackedScene
@export var bullet_speed : float



func attack() -> CharacterBody2D:
	var new_bullet = bullet_type.instantiate()
	new_bullet.bullet_speed = bullet_speed
	new_bullet.bullet_direction = aim_dir
	new_bullet.bullet_spread = bullet_spread
	new_bullet.damage = damage
	new_bullet.position = global.player_pos
	return new_bullet




func cool_down_timeout():
	cool_down = true























