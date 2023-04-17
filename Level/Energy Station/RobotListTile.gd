extends Button

var robot : Robot = null

func _ready():
	pass
func set_parent_gui(gui):
	if robot != null:
		pressed.connect(func(): gui.on_robot_selected(robot))
	pass
func set_robot(new_robot: Robot):
	robot = new_robot
	$RobotIcon.texture = robot.robot_type.get_icon()
	$RobotNameLabel.text = robot.robot_type.get_type_name()
