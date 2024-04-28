extends Area2D

@export var item : Item_Class

func _ready():
	$Sprite2D.texture = item.image

func _on_body_entered(body):
	if body == get_parent().get_node("player"):
		get_parent().get_node("item_handler").call("add_item" ,item)
	queue_free()
