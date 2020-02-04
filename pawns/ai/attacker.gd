extends Node2D

var Target = null
export var rotationLength = 2
export var headRotationSpeed = 0.1
export var circleRotationSpeed = 0.05
var precision = 150
var x = -2*PI
var y = 0

func _ready():
	#Attacker's circle around the parent, till they find a player
	Target = get_parent()

func _process(delta):
	position = Vector2(cos(x)*precision*rotationLength,sin(x)*precision*rotationLength)
#	position = position.linear_interpolate(vector+position, delta)

	
	var direction = get_direction_to_target()
	$Pivot/Sprite.rotation = lerp_angle($Pivot/Sprite.rotation, direction, headRotationSpeed)
	
	x += circleRotationSpeed * delta
	if (x > 2*PI):
		x = -2*PI

func get_direction_to_target():
	return Vector2(1, 0).angle_to( Target.position - self.position)

func lerp_angle(from, to, weight):
	return from + short_angle_dist(from, to) * weight

func short_angle_dist(from, to):
	var max_angle = PI * 2
	var difference = fmod(to - from, max_angle)
	return fmod(2 * difference, max_angle) - difference

func lerp_pos(from,to,weight):
	return from + to * weight
