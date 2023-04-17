extends Control 

@export var robot_list_tile = preload("res://Level/Energy Station/robot_list_tile.tscn")
@onready var robot_list = $RobotsListSection/ScrollContainer/RobotsList
@export var path_editing_gui : Control
var selected_robot = null

# Called when the node enters the scene tree for the first time.
func _ready():
	path_editing_gui.finished_editing.connect(end_editing)
	update_gui()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_robots(new_robots):
	for child in robot_list.get_children():
		child.queue_free()
		
	for robot in new_robots:
		print(robot)
		var new_tile = robot_list_tile.instantiate()
		new_tile.set_robot(robot)
		new_tile.set_parent_gui(self)
		robot_list.add_child(new_tile)
	pass

func on_robot_selected(robot):
	selected_robot = robot
	update_gui()
	pass

func update_gui():
	if selected_robot != null:
		$RobotDetails.visible = true
		$RobotDetails/RobotDescription/Control/RobotNameLabel.text = selected_robot.robot_type.get_type_name()
		$RobotDetails/RobotDescription/Control/RobotDescriptionLabel.text = selected_robot.robot_type.robot_description
		$RobotDetails/RobotDescription/RobotIcon.texture = selected_robot.robot_type.get_icon()
	else:
		$RobotDetails.visible = false
		pass
	pass


func _on_edit_path_button_pressed():
	visible = false
	path_editing_gui.start_editing(selected_robot)
	pass # Replace with function body.

func end_editing():
	visible = true
	pass
