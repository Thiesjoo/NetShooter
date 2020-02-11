extends Node

func back():
	if (get_tree().paused):
		if (!$UI/Pause.handle_back()):
			unpause()
	else:
		if (!$Level/Game/Player.interacting):
			pause()

func pause():
	get_tree().paused = true
	$UI/Pause.show()
	
func unpause():
	get_tree().paused = false
	$UI/Pause.hide()
