extends Node

func add_trainer(name, pos, type, index, scriptPath):
	var trainer1 = load("res://pawns/player/dynamic.tscn").instance()
	trainer1.get_node("Pivot/AnimatedSprite").index = index
	trainer1.position = pos
	trainer1.script = load("res://pawns/%s" % [scriptPath])
	trainer1.name = name
	trainer1.type = type
	return trainer1
