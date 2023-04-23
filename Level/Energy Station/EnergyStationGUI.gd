extends Control 

@export var robot_list_tile = preload("res://Level/Energy Station/robot_list_tile.tscn")
@export var path_editing_gui : Control

var selected_robot = null
var energy_station = null

signal changed_energy_station(energy_station: EnergyStation)
signal opened_menu
signal closed_menu
var level
# Called when the node enters the scene tree for the first time.
func _ready():
	level = get_node("/root/Level")
	path_editing_gui.finished_editing.connect(end_editing)
	update_gui()
	pass # Replace with function body.

func set_energy_station(new_energy_station: EnergyStation):
	energy_station = new_energy_station
	changed_energy_station.emit(energy_station)
	update_gui()
	pass

func on_robot_selected(robot):
	selected_robot = robot
	update_gui()
	pass

func update_gui():
	if selected_robot != null:
		var robot_type = level.lookup_robot(selected_robot.pickup_item)
		$RobotDetails.visible = true
		$RobotDetails/RobotDescription/Control/RobotNameLabel.text =robot_type.get_type_name()
		$RobotDetails/RobotDescription/Control/RobotDescriptionLabel.text = robot_type.robot_description
		$RobotDetails/RobotDescription/RobotIcon.texture = robot_type.get_icon()
		
	else:
		$RobotDetails.visible = false

		pass

	for child in $RobotsListSection/ScrollContainer/RobotsList.get_children():
		child.queue_free()
	
	if energy_station != null:
		for robot in energy_station.robots:
			var robot_type = level.lookup_robot(robot.pickup_item)
			
			var new_tile = robot_list_tile.instantiate()
			new_tile.set_robot(robot, robot_type.get_icon(), robot_type.get_type_name())
			new_tile.set_parent_gui(self)
			
			$RobotsListSection/ScrollContainer/RobotsList.add_child(new_tile)
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

func _on_add_robot_button_pressed():
	$RobotSelectionPopup.show()
	pass # Replace with function body.

func _on_place_robot_gui_button_pressed(item: InventoryItem, _amount):
	if level.place_robot_near_station(level.lookup_robot(item), energy_station):
		$RobotSelectionPopup.hide()
	pass # Replace with function body.


func _on_close_popup_button_pressed():
	$RobotSelectionPopup.hide()
	pass # Replace with function body.
