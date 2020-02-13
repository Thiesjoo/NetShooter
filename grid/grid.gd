extends TileMap

enum { EMPTY = -1, 
PLAYER, OBSTACLE, 
NPC, ATTACKER, 
COLLECTABLE,
TILE
}
var extraFunc
const chunk_size = 32*16 #Chunks is 32 tiles and cell_size is 16



func _ready():
	if (!Global.game_data):
		Scene_loader.switch_scene("main_menu")
		OS.alert("Something went wrong")
		return
	
	extraFunc = MapGen.new(self, chunk_size)
	add_child(extraFunc.add_trainer("Player", Global.game_data.player.position, PLAYER, 0, "player/player.gd"))
	for thingie in Global.game_data.map.trainers:
		add_child(extraFunc.add_trainer(thingie.npc_name, thingie.position, NPC, 4, "ai/staticNPC.gd"))


	for child in get_children():
		if ("type" in child):
			# Set the child in the tilemap and auto center it
			if (child.type != PLAYER):
				set_cellv(world_to_map(child.position), child.type)
			child.position = map_to_world(world_to_map(child.position)) + cell_size / 2
			

func save_data():
	var to_save = []
	for child in get_children():
		if ("type" in child):
			to_save.push({"x": child.pos.x, "y": child.pos.y, "type": child.type })
	return to_save

func _process(_delta):
	extraFunc.process(_delta)

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
			#TODO: Port this to Collision
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

func remove_object(coords):
	var object_pawn = get_cell_pawn(world_to_map(coords))
	set_cellv(world_to_map(coords),  EMPTY)
	object_pawn.queue_free()

func get_coords(object, offset=Vector2(0,0)):
	return world_to_map(object.position)+offset

func get_object(location):
	return get_cellv(location)
