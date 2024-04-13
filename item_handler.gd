extends Node


@export var item_list : JSON

var loaded_items


func reload_items():
	var json_text = item_list.get_as_text()
	loaded_items = JSON.parse_string(json_text)
