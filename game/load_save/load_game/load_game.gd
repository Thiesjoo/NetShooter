extends Node

onready var placeholder_scene = preload("res://game/load_save/placeholder.tscn")
var current_highlight = -1

func _ready():
	reload()
	get_child(0).grab_focus()

func submit(index):
	Global.load_game(index)
	Scene_loader.switch_scene("game")
	
func _on_Load_pressed():
	if (current_highlight > -1):
		submit(current_highlight)

func add_item(game, index):
	var temp = placeholder_scene.instance()
	temp.init(game, index)

	temp.name = str(index)
	add_child(temp)
	return temp

func reload():
	print("reloading load_game")
	delete_children()
	if (Global.games.size() > 0):
		for i in Global.games.size():
			var _temp = add_item(Global.games[i], i)
	else:
		var label = Label.new()
		label.text = "No games found!"
		add_child(label)

func delete_children():
	for n in get_children():
		remove_child(n)
		n.queue_free()
