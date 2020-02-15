extends Control
export var instanced_from = "main_menu"

func back():
	if (instanced_from == "callback"):
		get_parent().scene_close()
	else:
		Scene_loader.switch_scene(instanced_from)

func _on_Back_pressed():
	back()

func _input(event):
	if event.is_action_pressed("debug_ultra"):
		if (get_focus_owner()):
			print(get_focus_owner(),get_focus_owner().name)
