extends "../pawn.gd"

var Target = null
export var rotationLength = 10
export var rotationSpeed = 0.1

func _ready():
	#Attacker's circle around the parent, till they find a player
	Target = get_parent().get_node("Player")

func _process(delta):
	var direction = get_direction_to_target()
	var x = int(round(cos(direction)))
	var y = int(round(sin(direction)))
	if (x):
		update_look_direction(Vector2(x,0))
	else:
		update_look_direction(Vector2(0,y))

func get_direction_to_target():
	return Vector2(1, 0).angle_to(Target.position - self.position)
