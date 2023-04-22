extends HBoxContainer

var robot : RobotResource

func set_robot(new_robot : RobotResource, amount: int) -> void:
	robot = new_robot
	$AmountLabel.text = "%dx" % amount
	$NameLabel.text = new_robot.robot_type_name

func connect_to_place_button(callback: Callable) -> void:
	$PlaceButton.pressed.connect(func(): callback.call(robot))

