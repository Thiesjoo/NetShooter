extends Node

var loader
var wait_frames
var time_max = 100 # msec
var current_scene = null
onready var loading_scene = preload("res://game/global/Loading.tscn").instance()

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)

func _unhandled_key_input(event):
	if event.is_action_pressed("ui_cancel"):
		print("Back button pressed")
		if (current_scene.has_method("back")):
			current_scene.back()

func _process(_delta):
	if loader == null:
		set_process(false)
		return

	if wait_frames > 0: # wait for frames to let the "loading" animation show up
		wait_frames -= 1
		return

	var t = OS.get_ticks_msec()
	while OS.get_ticks_msec() < t + time_max: # use "time_max" to control for how long we block this thread

		# poll your loader
		var err = loader.poll()

		if err == ERR_FILE_EOF: # Finished loading.
			var resource = loader.get_resource()
			loader = null
			set_new_scene(resource)
			break
		elif err == OK:
			update_progress()
		else: # error during loading
			OS.alert("Something went wrong with loading the scene")
			loader = null
			break

func update_progress():
	var length = get_node("/root/LoadingScreen/AnimationPlayer").get_current_animation_length()
	var progress = float(loader.get_stage()) / loader.get_stage_count()
	
	get_node("/root/LoadingScreen/AnimationPlayer").seek(progress * length, true)

	# Update your progress bar?
	print("Loading scene progress: ", progress)
	get_node("/root/LoadingScreen/CenterContainer/VBoxContainer/CenterContainer/Progress").value = progress

func set_new_scene(scene_resource):
	current_scene = scene_resource.instance()
	get_node("/root/LoadingScreen/AnimationPlayer").play("fade_out")
#	get_tree().get_root().remove_child(loading_scene)
	get_node("/root").add_child(current_scene)



var scenes = {
"main_menu": "res://game/main_menu/main_menu.tscn",
"game": "res://Testing.tscn", 
"new_game": "res://Testing.tscn",
"load_game": "res://game/main_menu/load_game/load_game.tscn",
"credits": "res://game/credits/Credits.tscn",
"options": "res://Testing.tscn"
}

func switch_scene(name):
	call_deferred("_deferred_goto_scene", scenes[name])
	
func _deferred_goto_scene(path):
	loader = ResourceLoader.load_interactive(path)
	if loader == null: # check for errors
		OS.alert("Something went wrong with loading the scene")
		return
	set_process(true)
	# It is now safe to remove the current scene
	current_scene.free()
	get_tree().get_root().add_child(loading_scene)
	get_node("/root/LoadingScreen/AnimationPlayer").play("fade_in")
	wait_frames = 20
