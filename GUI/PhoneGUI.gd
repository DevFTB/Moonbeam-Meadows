extends TabContainer

signal opened_menu
signal closed_menu
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _input(event):
	if event is InputEventKey and event.is_action_pressed("open_menu") and not get_parent().get_children().filter(func(x): return x != self).any(func(x): return x.visible):
		visible = !visible
		if visible == true:
			opened_menu.emit()
		else:
			closed_menu.emit()
			