extends Node

onready var placeholder_scene = preload("res://game/main_menu/load_game/placeholder.tscn")
var current = -1

func _ready():
	print(Global.games)
	for i in Global.games.size():
		add_item(Global.games[i], i)

func _on_Load_pressed():
	if (current > -1):
		Global.load_game(current)
		Scene_loader.switch_scene("game")

func add_item(game, index):
	var temp = placeholder_scene.instance()
	temp.init(game)
	temp.connect("clicked", self, "_on_clicked", [index])
	temp.name = str(index)
	add_child(temp)
	
func _on_clicked(id):
	if (current > -1):
		get_child(current).disable_highlight()
	current = id
	get_child(current).highlight()
