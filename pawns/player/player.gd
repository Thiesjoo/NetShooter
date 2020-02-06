extends "../pawn.gd"

var interacting = false

func _ready():
	var camera = Camera2D.new()
	camera.zoom = Vector2(0.5, 0.5)
	camera.current = true
	add_child(camera)

func _process(delta):
	if (interacting):
		if (Input.is_action_pressed("ui_cancel")):
			interacting = false
			print("Interaction done")
		return

	#If there is a npc interact
	if (Input.is_action_pressed("ui_accept")):
		var target = Grid.request_move(self, current_direction)
		if ("interact" in target):
			print("interacting")
			interacting = true
		return

	#Otherwise, check input and act accordingly
	var input_direction = get_input_direction()

	if not input_direction:
		return

	update_look_direction(input_direction)

	var target = Grid.request_move(self, input_direction)

	if ("interact" in target):
		print("interacting")
		interacting = true
	elif ("collectable" in target):
		print(target)
		Grid.remove_object(target.pos)
		move_to(input_direction)
	elif ("move" in target):
		move_to(input_direction)
	elif ("bump" in target):
		bump()


func get_input_direction():
	var x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	var y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	if (x):
		return Vector2(x,0)
	else:
		return Vector2(0,y)



func _on_Player_area_entered(area):
	print("Collided with: ", area, area.type)
