extends "../staticNPC.gd"

export var rotationLength = 400
export var circleRotationSpeed = 2
export var amount_of_drones = 10
var drones = []

func _ready():
	for i in range(amount_of_drones):
		add_drone()

func _process(delta):
	for drone in drones:
		drone.rotation -= drone.get_node("Drone").circleSpeed * delta
		if (drone.rotation < 0):
			drone.rotation = 2*PI

func add_drone():
	var pivot = load("res://pawns/ai/attacker/drone.tscn").instance()
	var drone = pivot.get_node("Drone")
	drone.position = Vector2(rotationLength * randf(), 0)
	pivot.name = "Drone"
	drone.circleSpeed = circleRotationSpeed * randf()
	add_child(pivot)
	drones.append(pivot)
