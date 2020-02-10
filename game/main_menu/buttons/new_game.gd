extends "Button.gd"
 
func _on_click(_meta):
	Global.new_game()
	Scene_loader.switch_scene("new_game")
