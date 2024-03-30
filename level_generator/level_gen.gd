extends Node2D


@onready var tile_map = $TileMap
@onready var tile_values = "res://tileSets/tileValues.json"

var map_size = Vector2(3,3)
var wave_function : Array
var map_built = false

var size : Vector2
var stack : Array

var collapsed_tile_count = 0

var base_tile

func _ready():
#	tile_map.set_cell(0,Vector2(0,0), 0,Vector2(0,0))
#	load_tile_data()

	base_tile = load_tile_data()
	map_initialize(map_size, load_tile_data())
	#test()



func  _process(delta):

	if check_all() == false:
		iterate()
	elif map_built == false:
		build_map()

	if Input.is_action_just_pressed("debug"):
		print(wave_function)

func build_map():
	var b_coords = Vector2(0,0)
	for x in wave_function:
		b_coords.x += 1
		b_coords.y = 0
		for cell in x:
			b_coords.y += 1
			var this_cell = cell.keys()
			var atlas = Vector2(cell[this_cell[0]]["tileX"],cell[this_cell[0]]["tileY"])
			tile_map.set_cell(0,b_coords, 0,atlas)
	map_built = true

func iterate():
	var coords = get_min_entropy_tiles()
	collapse(coords)
	propagate()


func check_all():
	var count = 0
	for x in wave_function:
		for y in x:
			if y.size() == 1:
				count += 1
	if count == map_size.x * map_size.y:
		return true
	else:
		return false


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

func collapse_random_tile():
	var coords = Vector2(randi_range(0,map_size.x - 1), randi_range(0,map_size.y - 1))
	var rando = wave_function[coords.x][coords.y]
	var tile_list = {}
	for i in rando.keys():
		tile_list[i] = rando[i]["weight"]
	var chosen_tile = WeightedChoice.pick(tile_list)
	add_stack_neibours(coords)

func collapse(coords: Vector2):
	var tile = wave_function[coords.x][coords.y]
	var tile_list = {}
	for i in tile.keys():
		tile_list[i] = tile[i]["weight"]
	var chosen_tile = WeightedChoice.pick(tile_list)
	wave_function[coords.x][coords.y].clear()
	wave_function[coords.x][coords.y][chosen_tile] = base_tile[chosen_tile]
	collapsed_tile_count += 1
	add_stack_neibours(coords)

func delete_tile(tile : String, coords : Vector2):
	if wave_function[coords.x][coords.y].size() > 1:
		wave_function[coords.x][coords.y].erase(tile)



func propagate():
	for i in stack:
		if wave_function[i.x][i.y].size() > 1:
			var deletion_list = []


			for tile in wave_function[i.x][i.y]:
				var erased = false

				if i.x + 1 <= map_size.x - 1:
					for n_tile in wave_function[i.x + 1][i.y]:
						if wave_function[i.x][i.y][tile].get("posX") != wave_function[i.x + 1][i.y][n_tile].get("negX"):
							if deletion_list.has(tile) != true:
								deletion_list.append(tile)
								add_stack_neibours(Vector2(i.x, i.y))
								erased = true
								break
				if erased:
					continue


				if i.x - 1 >= 0:
					for n_tile in wave_function[i.x - 1][i.y]:
						if wave_function[i.x][i.y][tile].get("negX") != wave_function[i.x - 1][i.y][n_tile].get("posX"):
							if deletion_list.has(tile) != true:
								deletion_list.append(tile)
								add_stack_neibours(Vector2(i.x, i.y))
								erased = true
								break
				if erased:
					continue


				if i.y + 1 <= map_size.y - 1:
					for n_tile in wave_function[i.x][i.y + 1]:
						if wave_function[i.x][i.y][tile].get("posY") != wave_function[i.x][i.y + 1][n_tile].get("negY"):
							if deletion_list.has(tile) != true:
								deletion_list.append(tile)
								add_stack_neibours(Vector2(i.x, i.y))
								erased = true
								break
				if erased:
					continue

				if i.y - 1 >= 0:
					for n_tile in wave_function[i.x][i.y - 1]:
						if wave_function[i.x][i.y][tile].get("negY") != wave_function[i.x][i.y - 1][n_tile].get("posY"):
							if deletion_list.has(tile) != true:
								deletion_list.append(tile)
								add_stack_neibours(Vector2(i.x, i.y))
								erased = true
								break
				if erased:
					continue



			for del in deletion_list:
				delete_tile(del, Vector2(i.x,i.y))

			stack.erase(i)
		else:
			stack.erase(i)




func add_stack_neibours(coords : Vector2):
	if coords.x +1 <= map_size.x - 1:
		stack.append(Vector2(coords.x + 1, coords.y))
	if coords.x - 1 >= 0:
		stack.append(Vector2(coords.x - 1, coords.y))
	if coords.y + 1 <= map_size.y - 1:
		stack.append(Vector2(coords.x, coords.y + 1))
	if coords.y -1 >= 0:
		stack.append(Vector2(coords.x, coords.y - 1))


func get_entropy(coords : Vector2):
	return len(wave_function[coords.x][coords.y])

	'''
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
	'''

func get_min_entropy_tiles():
	var min_entropy
	var coords
	for x in range(size.y):
		for y in range(size.x):
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
