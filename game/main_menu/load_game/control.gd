extends Node

func back():
	Scene_loader.switch_scene("main_menu")

func _on_Back_pressed():
	back()
