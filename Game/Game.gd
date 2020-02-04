extends Node

func _ready():
	print("Game scene has started")

func _process(delta):
	if Input.is_action_pressed("key_exit"):
		print("Exitting game")
		get_tree().quit()
