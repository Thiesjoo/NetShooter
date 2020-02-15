extends Control

onready var load_scene = preload("res://game/load_save/load_game/load_game.tscn")
onready var save_scene = preload("res://game/load_save/save_game/save_game.tscn")
onready var unpause_button = $ColorRect/CenterContainer/VBoxContainer/Unpause

var active_scene = null
var prev_owner = null


func scene_close():
	remove_child(active_scene)
	active_scene.queue_free()
	active_scene = null
	set_focus(Control.FOCUS_ALL)
	if (prev_owner):
		prev_owner.grab_focus()
		prev_owner = null
	else:
		unpause_button.grab_focus()

func _on_Unpause_pressed():
	get_node("../../").unpause()

func _on_Load_pressed():
	prev_owner = get_focus_owner()
	var new_scene = load_scene.instance()
	new_scene.instanced_from = "callback"
	add_child(new_scene)
	active_scene = new_scene
	set_focus(Control.FOCUS_NONE)


func handle_back():
	if (active_scene != null):
		scene_close()
		return true
	else:
		return false


func _on_Exit_pressed():
	Global.save_game_and_exit("main_menu")

func _on_Save_pressed():
	prev_owner = get_focus_owner()
	print(prev_owner.name)
	var new_scene = save_scene.instance()
	new_scene.instanced_from = "callback"
	add_child(new_scene)
	active_scene = new_scene
	set_focus(Control.FOCUS_NONE)

func set_focus(mode):
	var parent = $ColorRect/CenterContainer/VBoxContainer
	parent.get_node("Exit").focus_mode = mode
	parent.get_node("Unpause").focus_mode = mode
	parent.get_node("Load").focus_mode = mode
	parent.get_node("Save").focus_mode = mode

func _on_Pause_visibility_changed():
	if (!get_focus_owner()):
		unpause_button.grab_focus()

