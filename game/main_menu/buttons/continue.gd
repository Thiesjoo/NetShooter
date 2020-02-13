extends "Button.gd"



func _on_click(_meta):
	#Load the most recent game. Games are stored in date order
	Global.load_game(0)
	Scene_loader.switch_scene("game")
