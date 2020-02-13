extends RichTextLabel
 
func _ready():
	var _temp = connect("meta_clicked", self, "_on_click")
	_temp = connect("mouse_entered", self, "_on_mouse_entered")
	_temp = connect("mouse_exited", self, "_on_mouse_exited")
	_temp = connect("focus_entered", self, "_on_mouse_entered")
	_temp = connect("focus_exited", self, "_on_mouse_exited")
	if (name == "Continue"):
		if (Global.games.size() > 0):
			show()
			grab_focus()
		else:
			hide()
			get_node(focus_next).grab_focus()

func _on_mouse_entered():
	bbcode_text = "[url][color=%s]%s[/color][url]" % [get_parent().highlight_color, name]
	grab_focus()

func _on_mouse_exited():
	bbcode_text = "[url][color=%s]%s[/color][url]" % ["white", name]
	release_focus()

func _on_click(_meta):
	pass

func _gui_input(_event):
	if (Input.is_action_just_released("ui_accept")):
		_on_click(null)
