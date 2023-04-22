extends Button

var robot : Robot = null

func _ready():
	pass
func set_parent_gui(gui):
	if robot != null:
		pressed.connect(func(): gui.on_robot_selected(robot))
	pass
func set_robot(new_robot: Robot, icon, type_name):
	robot = new_robot
	$RobotIcon.texture = icon
	$RobotNameLabel.text = type_name 
