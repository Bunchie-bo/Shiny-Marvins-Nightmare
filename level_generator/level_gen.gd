extends Node2D


@onready var tile_map = $TileMap
@onready var tile_values = "res://tileSets/tileValues.json"

var map_size = Vector2(4,4)
var wave_function : Array

var size : Vector2
var stack : Array



func _ready():
	tile_map.set_cell(0,Vector2(0,0), 0,Vector2(0,0))
#	load_tile_data()
	map_initialize(map_size, load_tile_data())
	test()



func load_tile_data():
	var file = FileAccess.open(tile_values, FileAccess.READ)
	var text = file.get_as_text()
	var tile_data = JSON.parse_string(text)
	return tile_data



func map_initialize(new_map_size : Vector2, tiles : Dictionary):
	size = new_map_size
	'''
	for _y in range(size.y):
		var y = []
		for _x in range(size.x):
			var x = []
			x.append(tiles.duplicate())
			y.append(x)
			wave_function.append(y)
	'''
	#need to make a y array and fill it with x.map_size number of x arrays holding the tile data,
	#the function above is making 4 x ararys per y array
	for _y in size.y:
		var y = []
		for _x in size.x:
			var x = []
			x.append(tiles.duplicate())
			y.append(x)
			wave_function.append(y)



func test():
	for i in wave_function:
		print(i[0])











