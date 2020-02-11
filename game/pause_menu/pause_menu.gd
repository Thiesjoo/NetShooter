extends Control

onready var load_scene = preload("res://game/load_save/load_game/load_game.tscn").instance()
onready var save_scene = preload("res://game/load_save/save_game/save_game.tscn").instance()

var active_scene = null

func _ready():
	load_scene.instanced_from = "callback"
	save_scene.instanced_from = "callback"
	
func scene_close():
	remove_child(active_scene)
	active_scene = null

func _on_Unpause_pressed():
	get_node("../../").unpause()

func _on_Load_pressed():
	add_child(load_scene)
	active_scene = load_scene

func handle_back():
	if (active_scene != null):
		scene_close()
		return true
	else:
		return false


func _on_Exit_pressed():
	load_scene.free()
	save_scene.free()
	Global.save_game_and_exit("main_menu")

func _on_Save_pressed():
	add_child(save_scene)
	active_scene = save_scene

