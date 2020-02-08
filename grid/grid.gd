extends TileMap

enum { EMPTY = -1, 
PLAYER, OBSTACLE, 
NPC, ATTACKER, 
COLLECTABLE,
TILE
}
var extraFunc

func _ready():
	extraFunc = preload("res://grid/mapgen/grid_func.gd").new()
	add_child(extraFunc.add_trainer("Player", Vector2(200,200), PLAYER, 0, "player/player.gd"))
	add_child(extraFunc.add_trainer("testing", Vector2(100,200), NPC, 4, "ai/staticNPC.gd"))
	

	for child in get_children():
		if ("type" in child):
			# Set the child in the tilemap and auto center it
			if (child.type != PLAYER):
				set_cellv(world_to_map(child.position), child.type)
			child.position = map_to_world(world_to_map(child.position)) + cell_size / 2
	generate_map()
	
func generate_map():
	var noise = OpenSimplexNoise.new()

	# Configure
	noise.seed = randi()
	noise.octaves = 1
	noise.period = 30.0
	noise.persistence = 0.8
	
	var map_size = Vector2(500,500)

	for x in map_size.x:
		for y in map_size.x:
			var a = noise.get_noise_2d(x,y)
			if a < 0.3 and a > 0.05:
#				print("Setting cell")
				set_cellv(Vector2(x,y),6)
			elif a < 0.5:
				set_cellv(Vector2(x,y), 5)
	update_bitmask_region(Vector2(0,0), map_size)
	

func get_cell_pawn(coordinates):
	for node in get_children():
		if world_to_map(node.position) == coordinates:
			return(node)


#Request move does nothing, expect returning what is in the next cell
func request_move(pawn, direction):
	var cell_start = world_to_map(pawn.position)
	var cell_target = cell_start + direction
	var cell_target_type = get_cellv(cell_target)

	match cell_target_type:
		EMPTY:
			return {"move": true, "pos": map_to_world(cell_target) }
		COLLECTABLE:
			print("Player should get xp or money")
			return {"collectable": true, "pos": map_to_world(cell_target) }
		NPC:
			var pawn2 = get_cell_pawn(cell_target)
			var pawn_name = pawn2.name
			print("Player want to interact with %s" % [pawn_name])
			return {"interact": true}
		ATTACKER:
			print("Player should be fucked now")
			return {"enemy": true, "pawn": get_cell_pawn(cell_target)}
		OBSTACLE:
			return {"bump": true}
	return {"move": true, "pos": map_to_world(cell_target) }

func update_pawn_position(pawn, cell_start, cell_target):
	if (pawn.type != PLAYER):
		set_cellv(cell_start, EMPTY)
		set_cellv(cell_target, pawn.type)
	return map_to_world(cell_target) + cell_size / 2
#
#func update_pawn(pawn, direction):
#	var cell_start = world_to_map(pawn.position)
#	var cell_target = cell_start + direction
#	return update_pawn_position(pawn, cell_start, cell_target)
	
func remove_object(coords):
	var object_pawn = get_cell_pawn(world_to_map(coords))
	set_cellv(world_to_map(coords),  EMPTY)
	object_pawn.queue_free()

func get_coords(object, offset=Vector2(0,0)):
	return world_to_map(object.position)+offset

func get_object(location):
	return get_cellv(location)


