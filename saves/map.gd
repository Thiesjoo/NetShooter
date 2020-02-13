extends Node

class_name Map
var Self = load("res://saves/map.gd")

export var map_seed = 0 
export var explored_chunks = []
export var trainers = [] 

func _init(_map_seed = randi(), _explored_chunks=[], _trainers=[]):
	map_seed = _map_seed
	trainers = [Trainer.new("ya yeet", [], 0, Vector2(100,100)), Trainer.new("1ya yeet", [], 0, Vector2(100,200))]
	explored_chunks = _explored_chunks
	
func clone():
	var new_trainers = []
	for trainer in trainers:
		new_trainers.append(trainer.clone())
	return Self.new(map_seed, explored_chunks, new_trainers)


func json():
	var parsed_trainers = []
	for trainer in trainers:
		parsed_trainers.append(trainer.json())
	var parsed_chunks = []
	for vector in explored_chunks:
		parsed_chunks.append({"x": vector.x, "y": vector.y})
	return {"trainers": parsed_trainers, "explored_chunks": parsed_chunks, "map_seed": map_seed}

func from_json(map):
	map_seed = map.map_seed
	for new_vector in map.explored_chunks:
		explored_chunks.append(Vector2(new_vector.x, new_vector.y))
	for new_trainer in map.trainers:
		var _trainer = Trainer.new()
		_trainer.from_json(new_trainer)
		trainers.append(_trainer)
