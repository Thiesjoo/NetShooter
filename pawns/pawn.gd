extends "objects.gd"

class_name Pawn

onready var Grid = get_parent()
var walk_time = 0.3

func _ready():
	update_look_direction(Vector2(1, 0))

func update_look_direction(dir):
	$Pivot/AnimatedSprite.play(vector_to_direction(dir))
	$Pivot/AnimatedSprite.advance()
	$Pivot/AnimatedSprite.stop()

func move_to(target_position, dir):
	set_process(false)
	$Pivot/AnimatedSprite.play(vector_to_direction(dir))

	# The node is moved as a whole. This is too also move the children in a Tween fashion
	$Tween.interpolate_property(self, "position", position, target_position, walk_time, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()

	# Stop the function execution until the tween finished
	yield($Tween, "tween_completed")
	$Pivot/AnimatedSprite.stop()
#	$Pivot/AnimatedSprite.frame = 0
	
	set_process(true)


func bump():
	#TODO: Play audio effect
	pass

func vector_to_direction(dir):
	if (dir == Vector2(0,1)):
		return "down"
	elif (dir == Vector2(0,-1)):
		return "up"
	elif (dir == Vector2(1,0)):
		return "right"
	elif (dir == Vector2(-1,0)):
		return "left"
	return ""
