extends RichTextLabel
 
func _ready():
	connect("meta_clicked", self, "_on_click")
	connect("mouse_entered", self, "_on_mouse_entered")
	connect("mouse_exited", self, "_on_mouse_exited")
	if (name == "Continue"):
		if (Global.games.size() > 0):
			show()
		else:
			hide()

func _on_mouse_entered():
	bbcode_text = "[url][color=%s]%s[/color][url]" % [get_parent().highlight_color, name]

func _on_mouse_exited():
	bbcode_text = "[url][color=%s]%s[/color][url]" % ["white", name]

func _on_click(_meta):
	pass
