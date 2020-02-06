extends Node

func _ready():
	print("Global game script has started")

func _process(delta):
	if Input.is_action_pressed("ui_end"):
		exit()

func exit():
	save()
	print("Exitting game")
	get_tree().quit()


func save():
	print("Saving user data")
	#User data
	
	print("Saving map")
	#Map 
	
	
