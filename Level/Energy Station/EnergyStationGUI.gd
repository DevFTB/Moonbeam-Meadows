extends Control 

@export var robot_list_tile = preload("res://Level/Energy Station/robot_list_tile.tscn")
@onready var robot_list = $RobotsListSection/ScrollContainer/RobotsList
@export var path_editing_gui : Control
var selected_robot = null
var energy_station = null

# Called when the node enters the scene tree for the first time.
func _ready():
	path_editing_gui.finished_editing.connect(end_editing)
	update_gui()
	pass # Replace with function body.


func set_energy_station(new_energy_station: EnergyStation):
	energy_station = new_energy_station
	for child in robot_list.get_children():
		child.queue_free()
		
	for robot in energy_station.robots:
		(robot)
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
	path_editing_gui.start_editing(selected_robot, energy_station)
	energy_station.show_area()
	pass # Replace with function body.

func end_editing():
	visible = true
	energy_station.hide_area()
	pass

func can_show():
	return not get_parent().get_children().filter(func(x): return x != self).any(func(x): return x.visible)
	
