extends "../pawn.gd"

var interacting = false

func _ready():
	var camera = Camera2D.new()
	camera.zoom = Vector2(0.25, 0.25)
	camera.current = true
	add_child(camera)


#Stop animation once key is removed
func _input(event):
	if (Input.is_action_just_released("ui_left") || Input.is_action_just_released("ui_right") || Input.is_action_just_released("ui_up") || Input.is_action_just_released("ui_down")):
		$Pivot/AnimatedSprite.stop()
	

func _process(_delta):

	if (interacting):
		$Pivot/AnimatedSprite.stop()
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

#Request move provides data about the square that is in the next direction
	var target = Grid.request_move(self, input_direction)

	if ("interact" in target):
		print("interacting")
		interacting = true
	elif ("collectable" in target):
		print(target)
		Grid.remove_object(target.pos)
		move_to(input_direction, target.pos)
	elif ("move" in target):
		move_to(input_direction, target.pos)
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
	print("Collided with: ", area)



func _on_Player_area_shape_entered(area_id, area, area_shape, self_shape):
	print("Collided with area shape", area)
