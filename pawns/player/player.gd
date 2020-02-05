extends "../pawn.gd"

func _ready():
	var camera = Camera2D.new()
	camera.zoom = Vector2(0.5, 0.5)
	camera.current = true
	add_child(camera)

func _process(delta):
	var input_direction = get_input_direction()

	if not input_direction:
		return
	update_look_direction(input_direction)

	var target_position = Grid.request_move(self, input_direction)
	if target_position:
		move_to(target_position, input_direction)
	else:
		bump()


func get_input_direction():
	var x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	var y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	if (x):
		return Vector2(x,0)
	else:
		return Vector2(0,y)
