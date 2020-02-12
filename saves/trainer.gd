extends Node

class_name Trainer
var Self = load("res://saves/trainer.gd")

export var npc_name: String = ""
export var inventory: Array = [] #{item: {hp: 0, xp: 0, }}
export var xp: int = 0 #Data gathered from sheet
export var position = Vector2(0,0)

func _init(_name="Pokemon Trainer", _inventory=[], _xp=0, _pos=Vector2(0,0)):
	npc_name = _name
	inventory = _inventory
	xp = _xp
	position = _pos

func add_item(item):
	inventory.append(item)

func clone():
	return Self.new(npc_name, inventory, xp)

func json():
	return {"npc_name": npc_name, "inventory": inventory, "xp": xp, "pos": {"x": position.x, "y": position.y}}

func from_json(trainer):
	npc_name = trainer.npc_name
	inventory = trainer.inventory
	xp = trainer.xp
	position = Vector2(trainer.pos.x, trainer.pos.y)
