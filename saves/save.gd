extends Node

class_name Savegame
var Self = load("res://saves/save.gd")

var map: Map = null
var save_name: String = ""
var thumbnail: Texture = null
var created_at: int = 0
var last_modified: int = 0
var player: Trainer = null

func _init(_name = "New save", _map = Map.new(), _thumbnail = null, _created_at= OS.get_unix_time(), _last_modified=OS.get_unix_time(), _player=Trainer.new("Ya yeet")):
	thumbnail = _thumbnail
	save_name = _name
	map = _map
	last_modified = _last_modified
	created_at = _created_at
	player = _player
	print("Map: ", map, map.map_seed)


func clone() -> Savegame:
	return Self.new(save_name, map.clone(), thumbnail, created_at, last_modified, player.clone())

func json() -> Dictionary:
	return {"map": map.json(), "save_name": save_name, "created_at": created_at, "last_modified": last_modified, "player": player.json()}

func from_json(save):
	var map = Map.new()
	map.from_json(save.map)
	var player = Trainer.new()
	player.from_json(save.player)
	created_at = save.created_at
	last_modified = save.last_modified
	save_name = save.save_name
