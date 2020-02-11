extends Node

signal clicked
var mouse_over = false
var current_index = -1
export var temp = ""

func _input(event):
	if Input.is_mouse_button_pressed(1):
		if mouse_over == true:
			emit_signal("clicked")


func init(game, index):
	current_index = index
	if ("temp" in game):
		temp = "New save"
	var Title_node = $MarginContainer/VBoxContainer/TitleContainer/Title
	var Date_node = $MarginContainer/VBoxContainer/Date
	var Data_node = $MarginContainer/VBoxContainer/Player_data
	var Thumbnail_node = $Thumbnail

	if (game.thumbnail):
		Thumbnail_node.texture = game.thumbnail
		
	Title_node.text = game.name
	
	var date = OS.get_datetime_from_unix_time(game.last_modified)
	Date_node.text = "Last modified: %s-%s-%s (DD-MM-YYYY)" % [date.day, date.month, date.year]
	
	#TODO: Make something sensible from this
	if (temp.length() < 1):
		date = OS.get_datetime_from_unix_time(game.created_at)
		var date_string = "%s-%s-%s (DD-MM-YYYY)" % [date.day, date.month, date.year]
		var data = "Seed: %s \nCreated at: %s" % [game.map_seed, date_string]
		Data_node.text = data

	
func highlight():
	var Thumbnail_border = $Thumbnail/Border
	Thumbnail_border.visible = true

func disable_highlight():
	var Thumbnail_border = $Thumbnail/Border
	Thumbnail_border.visible = false

func _on_Game_focus():
	mouse_over = true

func _on_Game_lost_focus():
	mouse_over = false

func _on_Title_text_entered(new_text):
	if (new_text.length() > 1):
		if (temp.length() > 0):
			temp = new_text
		else:
			Global.games[current_index].name = new_text
		var Title_node = $MarginContainer/VBoxContainer/TitleContainer/Title
		Title_node.release_focus()
	else:
		OS.alert("Please enter a name")


func _on_Delete_pressed():
	var dialog = $MarginContainer/VBoxContainer/TitleContainer/CenterContainer/DeleteDialog
	dialog.popup()

func _on_DeleteDialog_confirmed():
	Global.games.remove(current_index)
	get_parent().reload()
