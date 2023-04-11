extends TabContainer

signal opened_menu

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _input(event):
	if event is InputEventKey and event.is_action_pressed("open_menu"):
		visible = !visible
		if visible == true:
			opened_menu.emit()