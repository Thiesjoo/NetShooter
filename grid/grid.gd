extends TileMap

enum { EMPTY = -1, 
PLAYER, OBSTACLE, 
NPC, ATTACKER, 
COLLECTABLE,
DEVICE, GYM
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
		EMPTY, TILE:
			return {"move": true, }
		COLLECTABLE:
			print("Player should get xp or money")
			return {"collectable": true, "pos": cell_target }
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
	return {}

func update_pawn_position(pawn, cell_start, cell_target):
	if (pawn.type != PLAYER):
		set_cellv(cell_start, EMPTY)
		set_cellv(cell_target, pawn.type)
	return map_to_world(cell_target) + cell_size / 2

func update_pawn(pawn, direction):
	var cell_start = world_to_map(pawn.position)
	var cell_target = cell_start + direction
	return update_pawn_position(pawn, cell_start, cell_target)
	
func remove_object(coords):
	var object_pawn = get_cell_pawn(coords)
	set_cellv(coords,  EMPTY)
	object_pawn.queue_free()

func get_coords(object, offset=Vector2(0,0)):
	return world_to_map(object.position)+offset

func get_object(location):
	return get_cellv(location)


