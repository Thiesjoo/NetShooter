extends TileMap

enum { EMPTY = -1, PLAYER, WALL, NPC, ATTACKER, COIN}

func _ready():
	for child in get_children():
		if ("type" in child):
			print(child.type)
			set_cellv(world_to_map(child.position), child.type)
		
func get_cell_pawn(coordinates):
	for node in get_children():
		if world_to_map(node.position) == coordinates:
			return(node)

func request_move(pawn, direction):
	var cell_start = world_to_map(pawn.position)
	var cell_target = cell_start + direction
	
	var cell_target_type = get_cellv(cell_target)
	match cell_target_type:
		EMPTY:
			return update_pawn_position(pawn, cell_start, cell_target)
		COIN:
			print("Player should get xp or money")
			var object_pawn = get_cell_pawn(cell_target)
			object_pawn.queue_free()
			return update_pawn_position(pawn, cell_start, cell_target)
		NPC:
			var pawn2 = get_cell_pawn(cell_target)
			var pawn_name = pawn2.name
			print("Player want to interact with %s" % [pawn_name])
		ATTACKER:
			print("Player should be fucked now")

func update_pawn_position(pawn, cell_start, cell_target):
	set_cellv(cell_target, pawn.type)
	set_cellv(cell_start, EMPTY)
	return map_to_world(cell_target) + cell_size / 2

func get_coords(object, offset=Vector2(0,0)):
	return world_to_map(object.position)+offset

func get_object(location):
	return get_cellv(location)
