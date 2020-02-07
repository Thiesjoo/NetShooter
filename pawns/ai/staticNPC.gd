extends "../pawn.gd"

var Target = null
export var look_at_player = true
var prevAngle = 0

func _ready():
	#Static NPC's always look at the player
	Target = get_parent().get_node("Player")

func _process(_delta):
	if (!look_at_player):
		return
	var angle = get_direction_to_target()
	if (angle == prevAngle):
		return
	prevAngle = angle
	var x = int(round(cos(angle)))
	var y = int(round(sin(angle)))
	if (x):
		update_look_direction(Vector2(x,0))
	else:
		update_look_direction(Vector2(0,y))

func get_direction_to_target():
	return Vector2(1, 0).angle_to(Target.position - self.position)
