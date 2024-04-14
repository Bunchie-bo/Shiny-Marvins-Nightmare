extends Node

@export var item_list : JSON

var current_items : Dictionary
var loaded_items
var new_run = true

func save():
	var defaults = FileAccess.open("res://items/defualt_item_list.json", FileAccess.READ)
	var text = defaults.get_as_text()
	var defaults_json_data = JSON.parse_string(text)
	var file = FileAccess.open("res://items/current_items.json",FileAccess.WRITE)
	file.store_line(JSON.stringify(defaults_json_data))

func file_load():
	if not FileAccess.file_exists("res://items/current_items.json"):
		save()
	var file = FileAccess.open("res://items/current_items.json", FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	current_items = data

func init():
	pass


func _ready():
	if new_run:
		file_load()


func add_item(item : Item_Class):
	current_items["normal_items"].append(item)
	update_player()

func update_player():
	get_parent().get_node("player").call("update_items", current_items)






