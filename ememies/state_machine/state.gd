extends Node
class_name EnemyState

@export var enemy : CharacterBody2D
@export var move_speed := 30.0
var player : CharacterBody2D

signal Transitioned

func Enter():
	pass

func Exit():
	pass

func Update(_delta: float):
	pass

func Physics_Update(_delta: float):
	pass
