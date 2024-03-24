extends Node2D


@onready var tile_map = $TileMap
@onready var tile_values = "res://tileSets/tileValues.json"

var map_size = Vector2(3,3)
var wave_function : Array

var size : Vector2
var stack : Array

var collapsed_tile_count = 0


func _ready():
#	tile_map.set_cell(0,Vector2(0,0), 0,Vector2(0,0))
#	load_tile_data()
	map_initialize(map_size, load_tile_data())
	test()

func iterate():
	var coords = get_min_entropy_tiles()
	collapse(coords)
	propagate(coords)





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



func collapse(coords: Vector2):
	#Collapses a tile in a list of cells with the least ammount of remaining tiles, in the
	#case of the first run, this would be a random tile out of any of the tiles on the board
	
	var tile = wave_function[coords.x][coords.y]
	var tile_list = {}
	for i in tile.keys():
		tile_list[i] = tile[i]["weight"]
	var chosen_tile = tile[WeightedChoice.pick(tile_list)]
	wave_function[coords.x][coords.y].clear()
	wave_function[coords.x][coords.y] = chosen_tile
	collapsed_tile_count += 1
	#adds the 4 neighboring tiles to the stack to be propagated
	stack.append(Vector2(coords.x + 1, coords.y))
	stack.append(Vector2(coords.x - 1, coords.y))
	stack.append(Vector2(coords.x, coords.y + 1))
	stack.append(Vector2(coords.x, coords.y - 1))
	#print(wave_function[coords.x][coords.y])

func propagate(coords: Vector2):
	print(stack)
	for i in stack:
		if wave_function[i.x][i.y].size() > 1:
			#print(wave_function[i.x][i.y])
			for tile in wave_function[i.x][i.y]:
				#check negx negy posx posy too see if the neighboring
				#tiles ``wave_function[i.x +1][i.y]`` and other sides too
				#if the string files are the same, and if so do nothing
				#and if not remove from wave_function[i.x][i.y]
				pass
			
			stack.erase(i)
		else:
			stack.erase(i)


func check_tile_neighbor():
	pass

func test():


	collapse_random_tile()
	propagate(Vector2(0,0))




	#for i in wave_function:
	#print(wave_function[0][0].values())

	#var list = wave_function[0][0].keys()
	#print(list)
	#list.erase("fill")
	#var epic = wave_function[0][0]["fill"]
	#print(epic["weight"])
	#collapse_random_tile()
	#var coords = Vector2(1,1)
	#collapse(coords)





func collapse_random_tile():
	var coords = Vector2(randi_range(0,map_size.x - 1), randi_range(0,map_size.y - 1))
	var rando = wave_function[coords.x][coords.y]
	var tile_list = {}
	for i in rando.keys():
		tile_list[i] = rando[i]["weight"]
	var chosen_tile = WeightedChoice.pick(tile_list)
	print(chosen_tile)
	
	stack.append(Vector2(coords.x + 1, coords.y))
	stack.append(Vector2(coords.x - 1, coords.y))
	stack.append(Vector2(coords.x, coords.y + 1))
	stack.append(Vector2(coords.x, coords.y - 1))




func get_cords(x : int, y : int): #not sure if ill keep this, its kinda bloat, maybe a get tile arg?
	return wave_function[x][y]





func get_entropy(coords : Vector2):
	return len(wave_function[coords.x][coords.y])

func get_min_entropy_tiles():
	var min_entropy
	var coords
	for x in range(size.x):
		for y in range(size.y):
			var entropy = get_entropy(Vector2(x,y))
			if entropy > 1:
				entropy += randf_range(-0.1, 0.1)

				if not min_entropy:
					min_entropy = entropy
					coords = Vector2(x, y)
				elif entropy < min_entropy:
					min_entropy = entropy
					coords = Vector2(x, y)
	return coords



