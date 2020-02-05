extends Sprite

export(int) var index = 7
var aPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	self.texture = load("res://pawns/sprites/%strainer.png" % index)
	
	aPlayer = AnimationPlayer.new()

	var names = ["up", "left", "down", "right"]
	for i in range(0,4):
		aPlayer.add_animation(names[i], add_anim(i*3))

	add_child(aPlayer)
	aPlayer.playback_speed = 2


func add_anim(frame_start):
	var walkAnimation = Animation.new()
	walkAnimation.add_track(0)
	walkAnimation.length = hframes*0.2
	
	var path = String(self.get_path()) + ":frame"
	walkAnimation.track_set_path(0, path)
	var i = 0
	while i < hframes:
		walkAnimation.track_insert_key(0, i/5.0, frame_start+i)
		i += 1
#	walkAnimation.value_track_set_update_mode(0, Animation.UPDATE_DISCRETE)
	walkAnimation.loop = 1
	return walkAnimation
	

func play(name):
	aPlayer.play(name)
	
func stop():
	aPlayer.stop(true)

func advance():
	aPlayer.advance(0)
