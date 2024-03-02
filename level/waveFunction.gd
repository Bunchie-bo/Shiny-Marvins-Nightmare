extends Node2D

@onready var tile_map = $TileMap
@onready var tile_values = "res://tileSets/tileValues.json"

var map_size = Vector2(32,32)
var wave_function : Array

var size : Vector2
var stack : Array

const TILE_NAME = "tile"
const WEIGHT = "weight"
const NEIGHBOURS = "valid_neighbours"


const TOP = "negY"
const BOTTOM = "posY"
const LEFT = "negX"
const RIGHT = "posX"

const dirs = [
	TOP,
	BOTTOM,
	LEFT,
	RIGHT
]

var direction_to_index = {
	Vector2.LEFT : 2,
	Vector2.RIGHT : 0,
	Vector2.UP : 4,
	Vector2.DOWN : 5
}



func load_tile_data():
	var file = FileAccess.open(tile_values, FileAccess.READ)
	var text = file.get_as_text()
	var tile_data = JSON.parse_string(text)
	return tile_data


func _ready():
	tile_map.set_cell(0,Vector2(0,0), 0,Vector2(0,0))
	load_tile_data()
	map_initialize(map_size, load_tile_data())
	

func _process(delta):
	if not is_collapsed():
		iterate()



func map_initialize(new_map_size : Vector2, tiles : Dictionary):
	size = new_map_size
	for _y in range(size.y):
		var x = []
		for _x in range(size.x):
			x.append(tiles.duplicate())
		wave_function.append(x)




func iterate():
	var coords = get_min_entropy_tiles()
	collapse_at(coords)
	propagate(coords)





func propagate(co_ords, single_iteration=false):
	if co_ords:
		stack.append(co_ords)
	while len(stack) > 0:
		var cur_coords = stack.pop_back()

		# Iterate over each adjacent cell to this one
		for d in valid_dirs(cur_coords):
			
			var other_coords = (cur_coords + d)
			#var possible_neighbours = get_possible_neighbours(cur_coords, d)  #old
			var possible_neighbours = check_neighbours(cur_coords, d)
			var other_possible_prototypes = get_possibilities(other_coords).duplicate()

			if len(other_possible_prototypes) == 0:
				continue

			for other_prototype in other_possible_prototypes:
				if not other_prototype in possible_neighbours:
					constrain(other_coords, other_prototype)
					if not other_coords in stack:
						stack.append(other_coords)
		if single_iteration:
			break



func check_neighbours(coords : Vector2, dir : Vector2):
	var valid_neighbours = []
	var tiles = get_possibilities(coords)
	var dir_idx = direction_to_index[dir]

	for tile in tiles:
		var neighbours = tiles[tile]
		for n in neighbours:
			pass



	return valid_neighbours






func get_possible_neighbours(coords : Vector2, dir : Vector2): 
	var valid_neighbours = []
	var tiles = get_possibilities(coords)
	var dir_idx = direction_to_index[dir]
	for tile in tiles:
		var neighbours = tiles[tile][NEIGHBOURS][dir_idx]
		for n in neighbours:
			if not n in valid_neighbours:
				valid_neighbours.append(n)
	return valid_neighbours


func valid_dirs(coords):
	var x = coords.x
	var y = coords.y
	
	var width = size.x
	var height = size.y
	var dirs = []
	
	if x > 0: dirs.append(Vector2.LEFT)
	if x < width-1: dirs.append(Vector2.RIGHT)
	if y > 0: dirs.append(Vector2.DOWN)
	if y < height-1: dirs.append(Vector2.UP)
	
	return dirs


func get_possibilities(coords : Vector2):
	return wave_function[coords.y][coords.x]

	#change to check the tile sides of said neighbours to see if they are vaild or not





func constrain(coords : Vector2, prototype_name : String):
	wave_function[coords.y][coords.x].erase(prototype_name)






func collapse_at(coords : Vector2):
	var possible_tile = wave_function[coords.y][coords.x]
	var selection = weighted_choice(possible_tile)
	var tile = possible_tile[selection]
	possible_tile = {selection : tile}
	wave_function[coords.y][coords.x] = possible_tile


func weighted_choice(tile_types):
	var tile_weights = {}
	for p in tile_types:
		var w = tile_types[p][WEIGHT]
		w += randi_range(-1.0, 1.0)
		tile_weights[w] = p
	var tile_list = tile_weights.keys()
	tile_list.sort()
	return tile_weights[tile_list[-1]]



func get_entropy(coords : Vector2):
	return len(wave_function[coords.y][coords.x])


func get_min_entropy_tiles():
	var min_entropy
	var coords
	for y in range(size.y):
		for x in range(size.x):
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





func is_collapsed():
	for y in wave_function:
		for x in y:
			if len(x) > 1:
				return false
	return true

