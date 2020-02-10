extends Node

signal clicked
var mouse_over = false

func _input(event):
	if Input.is_mouse_button_pressed(1):
		if mouse_over == true:
			emit_signal("clicked")


func init(game):
	var Title_node = $MarginContainer/VBoxContainer/Title
	var Date_node = $MarginContainer/VBoxContainer/Date
	var Data_node = $MarginContainer/VBoxContainer/Player_data
	var Thumbnail_node = $Thumbnail

	if (game.thumbnail):
		Thumbnail_node.texture = game.thumbnail
		
	Title_node.text = game.name
	
	var date = OS.get_datetime_from_unix_time(game.last_modified)
	Date_node.text = "Last modified: %s-%s-%s (DD-MM-YYYY)" % [date.day, date.month, date.year]
	
	#TODO: Make something sensible from this
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
