extends Sprite

export(int) var index = 7
var aPlayer: AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	self.texture = load("res://pawns/sprites/%strainer.png" % index)
	
	aPlayer = AnimationPlayer.new()

	var names = ["up", "left", "down", "right"]
	for i in range(0,4):
		aPlayer.add_animation(names[i], add_anim(i*3, hframes))

	add_child(aPlayer)
	aPlayer.playback_speed = 2


func add_anim(frame_start, amount_of_frames):
	var walkAnimation = Animation.new()
	walkAnimation.add_track(0)
	walkAnimation.length = amount_of_frames*0.2
	
	var path = String(self.get_path()) + ":frame"
	walkAnimation.track_set_path(0, path)
	var i = 0
	while i < amount_of_frames:
		walkAnimation.track_insert_key(0, i/5.0, frame_start+i)
		i += 1
	walkAnimation.value_track_set_update_mode(0, Animation.UPDATE_DISCRETE)
	walkAnimation.loop = 1
	return walkAnimation
	

func play(name):
	aPlayer.play(name)
	
func stop():
	#Set the animation to the first frame and then stop the animation. It will always rest on a idle posistion
	aPlayer.seek(0, true)
	aPlayer.stop()

func get_current():
	return aPlayer.assigned_animation
