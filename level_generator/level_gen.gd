extends Node2D


@onready var tile_map = $TileMap
@onready var tile_values = "res://tileSets/tileValues.json"

var map_size = Vector2(4,4)
var wave_function : Array

var size : Vector2
var stack : Array



func _ready():
#	tile_map.set_cell(0,Vector2(0,0), 0,Vector2(0,0))
#	load_tile_data()
	map_initialize(map_size, load_tile_data())
	collapse()
	
	#test()



func load_tile_data():
	var file = FileAccess.open(tile_values, FileAccess.READ)
	var text = file.get_as_text()
	var tile_data = JSON.parse_string(text)
	return tile_data



func map_initialize(new_map_size : Vector2, tiles : Dictionary):
	size = new_map_size
	var x = []
	for _y in range(size.x):
		var y = []
		for _x in range(size.y):
			y.append(tiles.duplicate())
		x.append(y)
	wave_function.append(x)






func collapse():
	#Collapses a tile in a list of cells with the least ammount of remaining tiles, in the
	#case of the first run, this would be a random tile out of any of the tiles on the board
	pass



func test():
	for i in wave_function:
		print(i[0][0])











