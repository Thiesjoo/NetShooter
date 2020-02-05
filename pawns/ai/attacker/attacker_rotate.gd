extends Node2D

export var rotationLength = 100
export var circleRotationSpeed = 2

func _ready():
	get_node("Attacker").position = Vector2(rotationLength, 0)

func _process(delta):
	rotation += circleRotationSpeed * delta
	if (rotation > 2*PI):
		rotation = 0
