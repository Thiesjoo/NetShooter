extends Node

onready var placeholder_scene = preload("res://game/load_save/placeholder.tscn")
var current = -1
var new_item = false

func _ready():
	reload()

func _on_Save_pressed():
	if (current > -1):
		#Temp means that it is a new save
		if (Global.games.has(get_child(current).current_save)):
			get_node("../../../../Dialog").popup()
		else:
			#Otherwise give a dialog about overwriting
			print("Edited data and tried to save the game")
			Global.games.push_front(get_child(current).current_save)
			Global.current_game_id = 0
			Global.game_data = get_child(current).current_save
			Global.save_game()
			back()
	else:
		OS.alert("Please select a slot")

func add_item(game, index):
	var temp = placeholder_scene.instance()
	temp.init(game, index)
	temp.connect("clicked", self, "_on_clicked", [index])
#	temp.name = str(index)
	add_child(temp)
	
func _on_clicked(id):
	if (current > -1):
		get_child(current).disable_highlight()
	current = id
	print(current)
	print(get_children())
	get_child(current).highlight()

func _on_New_pressed():
	if (!new_item):
		new_item = true
		add_item(Savegame.new(), Global.games.size())
		if (get_node("temp")):
			remove_child(get_node("temp"))
		_on_clicked(Global.games.size())

func _on_ConfirmationDialog_confirmed():
	#Only copy over the name from the old game. Overwrite the rest of the data
	Global.game_data.name = Global.games[current].name
	Global.games[current] = Global.game_data
	back()
	
func back():
	get_node("../../../../../").back()

func reload():
	new_item = false
	print("reloading load_game")
	delete_children()
	if (Global.games.size() > 0):
		for i in Global.games.size():
			add_item(Global.games[i], i)
	else:
		var label = Label.new()
		label.name = "temp"
		label.text = "No games found!"
		add_child(label)

func delete_children():
	for n in get_children():
		remove_child(n)
		n.queue_free()
