extends TileMap

enum { EMPTY = -1, PLAYER, WALL, NPC, ATTACKER, COIN}

func _ready():
	add_trainer("Player", Vector2(200,200), PLAYER, 0, "player/player.gd")
	add_trainer("testing", Vector2(100,200), NPC, 4, "ai/staticNPC.gd")

	

	for child in get_children():
		if ("type" in child):
			# Set the child in the tilemap and auto center it
			set_cellv(world_to_map(child.position), child.type)
			child.position = map_to_world(world_to_map(child.position)) + cell_size / 2
	

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
			print(pawn2)
			var pawn_name = pawn2.name
			print("Player want to interact with %s" % [pawn_name])
		ATTACKER:
			print("Player should be fucked now")

func update_pawn_position(pawn, cell_start, cell_target):
	set_cellv(cell_start, EMPTY)
	set_cellv(cell_target, pawn.type)
	return map_to_world(cell_target) + cell_size / 2

func get_coords(object, offset=Vector2(0,0)):
	return world_to_map(object.position)+offset

func get_object(location):
	return get_cellv(location)


func add_trainer(name, pos, type, index, scriptPath):
	var trainer1 = load("res://pawns/player/dynamic.tscn").instance()
	trainer1.get_node("Pivot/AnimatedSprite").index = index
	trainer1.position = pos
	trainer1.script = load("res://pawns/%s" % [scriptPath])
	trainer1.name = name
	trainer1.type = type
	add_child(trainer1)
