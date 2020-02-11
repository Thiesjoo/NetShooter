extends Node

onready var placeholder_scene = preload("res://game/load_save/placeholder.tscn")
var current = -1
var new_item = false

func _ready():
	assert("map_seed" in Global.game_data)
	reload()

func _on_Save_pressed():
	if (current > -1):
		if (get_child(current).temp.length() > 1):
			# We create a copy of the current game_state and push it to the array. Then we execute the save method to gather all data and add it to the new savee
			var temp = str2var(var2str(Global.game_data))
			temp.name = get_child(current).temp
			temp.map_seed = 123
			Global.games.push_front(temp)
			Global.current_game_id = 0
			print("Edited data and tried to save the game")
			Global.save_game()

			back()
		else:
			get_node("../../../../Dialog").popup()
	else:
		OS.alert("Please select a slot")

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

func _on_New_pressed():
	if (!new_item):
		new_item = true
		add_item({"temp": true, "name": "Enter name here...", "thumbnail": null, "created_at": OS.get_unix_time(), "last_modified": OS.get_unix_time()}, Global.games.size())
		_on_clicked(Global.games.size())

func _on_ConfirmationDialog_confirmed():
	Global.games[current] = Global.game_data
	back()
	
func back():
	get_node("../../../../../").back()

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
