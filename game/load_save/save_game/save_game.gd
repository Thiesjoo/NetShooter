extends Node

onready var placeholder_scene = preload("res://game/load_save/placeholder.tscn")
var current_highlight = -1
var new_item = false

func _ready():
	reload()
	get_child(0).grab_focus()

func _on_Save_pressed():
	if (current_highlight > -1):
		submit(current_highlight)
	else:
		OS.alert("Please select a slot")
		
func save_new_game():
	Global.games.push_front(get_child(current_highlight).current_save)
	Global.current_game_id = 0
	Global.game_data = get_child(current_highlight).current_save
	Global.save_game()
	new_item = false
	back()

func submit(index):
	if (index == Global.current_game_id):
		#Save is current save
		Global.save_game()
		back()
	elif(!Global.games.has(get_child(index).current_save)):
		#Save is new
		print("Edited data and tried to save the game")
		save_new_game()
	else:
		#Otherwise give a dialog about overwriting
		get_node("../../../../Dialog").popup()

func _on_New_pressed():
	if (!new_item):
		new_item = true
		#Remove the no game label, and add a savegame with the greatest index
		if (get_node("temp")):
			remove_child(get_node("temp"))
		add_item(Savegame.new(), Global.games.size())


func add_item(game, index):
	var temp = placeholder_scene.instance()
	temp.init(game, index)
	temp.name = str(index)
	add_child(temp)

func _on_ConfirmationDialog_confirmed():
	print("Confirmied")
	#Only copy over the name from the old game. Overwrite the rest of the data
	Global.game_data.name = Global.games[current_highlight].name
	Global.games[current_highlight] = Global.game_data
	back()
	
func back():
	get_node("../../../../../").back()

func reload():
	current_highlight = -1
	new_item = false
	print("reloading save_game")
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
