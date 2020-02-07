extends "../staticNPC.gd"

export var min_rotation_length = 200
export var min_circle_rotation_speed = 1
export var amount_of_drones = 10
var pivots = []

func _ready():
	for _i in range(amount_of_drones):
		add_drone()

func _process(delta):
	for pivot in pivots:
		pivot.rotation -= pivot.get_node("Drone").circleSpeed * delta
		if (pivot.rotation < 0):
			pivot.rotation = 2*PI

func add_drone():
	var pivot = load("res://pawns/ai/attacker/drone.tscn").instance()
	var drone = pivot.get_node("Drone")
	var test_rotation = (min_rotation_length+100) * randf()
	if (test_rotation < min_rotation_length):
		test_rotation = min_rotation_length
	var test_speed = (min_circle_rotation_speed+2) * randf()
	if (test_speed < min_circle_rotation_speed):
		test_speed = min_circle_rotation_speed
		
	drone.position = Vector2(test_rotation, 0)
	pivot.rotation = 2*PI*randf()
	drone.circleSpeed = test_speed
	
	pivot.name = "Drone"
	add_child(pivot)
	pivots.append(pivot)
	

