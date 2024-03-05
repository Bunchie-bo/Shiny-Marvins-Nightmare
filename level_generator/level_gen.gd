extends Node2D


@onready var tile_map = $TileMap
@onready var tile_values = "res://tileSets/tileValues.json"

var map_size = Vector2(6,6)
var wave_function : Array

var size : Vector2
var stack : Array



func _ready():
#	tile_map.set_cell(0,Vector2(0,0), 0,Vector2(0,0))
#	load_tile_data()
	map_initialize(map_size, load_tile_data())
	collapse()
	
	test()


func load_tile_data():
	var file = FileAccess.open(tile_values, FileAccess.READ)
	var text = file.get_as_text()
	var tile_data = JSON.parse_string(text)
	return tile_data


func map_initialize(new_map_size : Vector2, tiles : Dictionary):
	size = new_map_size
	for _x in range(size.x):
		var y = []
		for _y in range(size.y):
			y.append(tiles.duplicate())
		wave_function.append(y)



func collapse():
	#Collapses a tile in a list of cells with the least ammount of remaining tiles, in the
	#case of the first run, this would be a random tile out of any of the tiles on the board
	pass


func propagate():
	pass


func get_least_tile_count():
	
	pass




func test():
	#for i in wave_function:
	#print(wave_function[0][0].values())

	var list = wave_function[0][0].keys()
	#print(list)
	#list.erase("fill")
	var epic = wave_function[0][0]["fill"]
	print(epic["weight"])







func get_cords(x : int, y : int): #not sure if ill keep this, its kinda bloat, maybe a get tile arg?
	return wave_function[x][y]







