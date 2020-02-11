extends Node
export var instanced_from = "main_menu"

func back():
	if (instanced_from == "callback"):
		get_parent().scene_close()
	else:
		Scene_loader.switch_scene(instanced_from)

func _on_Back_pressed():
	back()
