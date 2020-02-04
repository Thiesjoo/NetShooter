extends "../objects.gd"

var Target = null
export var rotationLength = 10
export var rotationSpeed = 0.1

func _ready():
	#Attacker's circle around the parent, till they find a player
	Target = get_parent().get_node("Player")

func _process(delta):
	var direction = get_direction_to_target()
	$Pivot/Sprite.rotation = lerp_angle($Pivot/Sprite.rotation, direction, rotationSpeed)

func get_direction_to_target():
	return Vector2(1, 0).angle_to( Target.position - self.position)

func lerp_angle(from, to, weight):
	return from + short_angle_dist(from, to) * weight

func short_angle_dist(from, to):
	var max_angle = PI * 2
	var difference = fmod(to - from, max_angle)
	return fmod(2 * difference, max_angle) - difference
