extends OverscreenGUI

func _input(event):
	if event is InputEventKey and event.is_action_pressed("open_menu") and can_show():
		visible = !visible
		if visible == true:
			opened_menu.emit()
		else:
			closed_menu.emit()
			
