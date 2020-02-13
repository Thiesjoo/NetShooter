extends "../pawn.gd"

export var interacting = false
var navigation = []
var camera = null
var stopping = false
var ultra_speed =true

func _ready():
	camera = Camera2D.new()
	camera.zoom = Vector2(0.25, 0.25)
	camera.current = true
	add_child(camera)
	var _temp = connect("move_finished", self, "_move_finished_callback")

func _move_finished_callback():
	if stopping:
		$Pivot/AnimatedSprite.stop()
		stopping = false
	
#Stop animation once key is removed
func _input(_event):
	if (Input.is_action_just_released("ui_left") || Input.is_action_just_released("ui_right") || Input.is_action_just_released("ui_up") || Input.is_action_just_released("ui_down")):
		stopping = true
	if (Input.is_action_just_released("ui_page_down")):
		pass
#		var temp_navigation = get_node("../../").get_simple_path(position,get_global_mouse_position(), false)
#		#Turn navigation into direction s
#		navigation = [Vector2(0,1), Vector2(0,1)]
#		print("Navigation: ", temp_navigation)
		
	if (Input.is_action_just_pressed("debug_speed")):
		if (walk_time == 0.01):
			walk_time = 0.3
		else:
			walk_time = 0.01
	if (Input.is_action_just_pressed("debug_zoom")):
		if (camera.zoom == Vector2(0.25, 0.25)):
			camera.zoom = Vector2(2,2)
		else:
			camera.zoom = Vector2(0.25, 0.25)
	if (Input.is_action_just_pressed("debug_ultra")):
		if (ultra_speed):
			camera.zoom = Vector2(0.25, 0.25)
			walk_time = 0.3
			ultra_speed = false
		else:
			camera.zoom = Vector2(0.01, 0.01)
			walk_time = 0.001
			ultra_speed = true
	

func _process(_delta):
	#HACK: Very inefficient
	if(get_tree().paused):
		$Pivot/AnimatedSprite.stop()
		return
	
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
		Global.game_data.player.position = target.pos
	elif ("move" in target):
		move_to(input_direction, target.pos)
		Global.game_data.player.position = target.pos
	elif ("bump" in target):
		bump()


func get_input_direction():
	var x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	var y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	if (x):
		return Vector2(x,0)
	else:
		return Vector2(0,y)

