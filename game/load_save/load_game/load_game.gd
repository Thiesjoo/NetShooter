extends Node

onready var placeholder_scene = preload("res://game/load_save/placeholder.tscn")
var current = -1

func _ready():
	reload()

func _on_Load_pressed():
	if (current > -1):
		Global.load_game(current)
		Scene_loader.switch_scene("game")

func add_item(game, index):
	var temp = placeholder_scene.instance()
	temp.init(game, index)
	temp.connect("clicked", self, "_on_clicked", [index])
	temp.name = str(index)
	add_child(temp)
	
func _on_clicked(id):
	if (current > -1):
		get_child(current).disable_highlight()
	current = id
	get_child(current).highlight()

func reload():
	print("reloading load_game")
	delete_children()
	if (Global.games.size() > 0):
		for i in Global.games.size():
			add_item(Global.games[i], i)
	else:
		var label = Label.new()
		label.text = "No games found!"
		add_child(label)

func delete_children():
	for n in get_children():
		remove_child(n)
		n.queue_free()
