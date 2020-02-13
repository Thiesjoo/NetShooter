extends Node

class_name MapGen
var parent = null
var chunk_size = 0
var noise = OpenSimplexNoise.new()

const neighbour_list =  [Vector2(0,0),Vector2(1,0),Vector2(0,1),Vector2(1,1), Vector2(-1,-1),Vector2(1,-1),Vector2(-1,1),Vector2(-1,0),Vector2(0,-1)]

func _init(_parent: TileMap, _chunk_size):
	parent = _parent
	chunk_size = _chunk_size
	
	noise.seed = Global.game_data.map.map_seed
	noise.octaves = 1
	noise.period = 30.0
	noise.persistence = 0.8

func add_trainer(name, pos, type, index, scriptPath):
	var trainer1 = load("res://pawns/player/dynamic.tscn").instance()
	trainer1.get_node("Pivot/AnimatedSprite").index = index
	trainer1.position = pos
	trainer1.script = load("res://pawns/%s" % [scriptPath])
	trainer1.name = name
	trainer1.type = type
	return trainer1

var generated_chunks = []


func generate_map_chunk(start, end):
	for x in range(start.x,end.x):
		for y in range(start.y, end.y):
			if (y == 0 or x == 0):
				parent.set_cellv(Vector2(x,y), 8)
			else:
				var a = noise.get_noise_2d(x,y)
				if a < 0.3 and a > 0.05:
					parent.set_cellv(Vector2(x,y), 6)
				else:
					#TODO: Make multiple tile sets
					parent.set_cellv(Vector2(x,y), 5)
				
	parent.update_bitmask_region(Vector2(start.x-10,start.y-10), Vector2(end.x+10,end.y+10))


func process(_delta):
	var player_pos = Global.game_data.player.position
	var player_chunk = get_current_chunk(player_pos)
	
	var new_array = []
	for new_vector in neighbour_list:
		new_array.append(player_chunk+new_vector)

	for current_chunk in new_array:
		if (!generated_chunks.has(current_chunk)):
			var vector_1 = Vector2(current_chunk.x*32, current_chunk.y*32)
			var vector_2 = Vector2(current_chunk.x*32+32, current_chunk.y*32+32)
			generate_map_chunk(vector_1, vector_2)
			generated_chunks.append(current_chunk)
			if (Global.game_data.map.explored_chunks.has(current_chunk)):
				Global.game_data.map.explored_chunks.append(current_chunk)
	

func get_current_chunk(pos_vector: Vector2) -> Vector2:
	var new_vector = pos_vector/chunk_size
	return Vector2(int(new_vector.x), int(new_vector.y))
	
