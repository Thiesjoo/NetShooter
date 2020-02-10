extends "objects.gd"

class_name Pawn

onready var Grid = get_parent()
var walk_time = 0.3
var current_direction = Vector2(0,0)
signal move_finished

func _ready():
	update_look_direction(Vector2(1, 0))


#Player/enemy code

func update_look_direction(dir):
	var textDir = vector_to_direction(dir)
	if (textDir != $Pivot/AnimatedSprite.get_current()):
		current_direction = dir
		$Pivot/AnimatedSprite.play(textDir)
		$Pivot/AnimatedSprite.stop()

func move_to(dir, pos):

	$Pivot/AnimatedSprite.play(vector_to_direction(dir))
	set_process(false)
	# The node is moved as a whole. This is too also move the children in a Tween fashion
	$Tween.interpolate_property(self, "position", position, pos, walk_time, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()

	# Stop the function execution until the tween finished
	yield($Tween, "tween_completed")
	emit_signal("move_finished")
	set_process(true)



func bump():
	#TODO: Play audio effect
	print("BUMP!")

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


func _on_Player_area_entered(area):
	print("Collided with: ", area)
