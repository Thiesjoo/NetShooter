#SHould randomly move around a point
extends "../pawn.gd"

var locations= [[0,1], [1,1], [1,0], [0,-1],[-1,-1], [-1,0], [-1,1], [1, -1]]
var Target = null

func _ready():
	Target = get_parent().get_node("Player")

func _process(delta):
	var input_direction = get_input_direction()

	if not input_direction:
		return
	update_look_direction(input_direction)

	var target_position = Grid.request_move(self, input_direction)
	if target_position:
		move_to(target_position)
	else:
		bump()

func get_input_direction():
	var currentVector = null
#	print(Vector2(1, 0).angle_to( Target.position - self.position))

	for location in locations:
		currentVector = Vector2(location[0], location[1])
		var target = checkDir(currentVector)
		if (target == -1):
			break
	return currentVector

func checkDir(dir):
	var coords = Grid.get_coords(self, dir)
	return Grid.get_object(coords)
