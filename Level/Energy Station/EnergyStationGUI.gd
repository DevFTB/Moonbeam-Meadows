extends Control 

@export var robot_list_tile = preload("res://Level/Energy Station/robot_list_tile.tscn")
@export var path_editing_gui : Control
@export var robot_upgrade_gui : Control
@export var robot_details : Control
@export var robot_inv_list : Control

var selected_robot = null
var energy_station = null

signal changed_energy_station(energy_station: EnergyStation)
signal changed_selected_robot(robot: Robot)
signal opened_menu
signal closed_menu
var level
# Called when the node enters the scene tree for the first time.
func _ready():
	identify_camera.finished_tracking.connect(on_identify_camera_finished_tracking)
	level = get_node("/root/Level")
	path_editing_gui.finished_editing.connect(end_editing)
	update_gui()

	pass # Replace with function body.

func set_energy_station(new_energy_station: EnergyStation):
	energy_station = new_energy_station
	changed_energy_station.emit(energy_station)
	if not energy_station.robot_removed.is_connected(on_remove_robot):
		energy_station.robot_removed.connect(on_remove_robot)

	update_gui()
	pass
func on_remove_robot(robot: Robot):
	selected_robot = null
func on_robot_selected(robot):
	selected_robot = robot
	changed_selected_robot.emit(selected_robot)
	update_gui()
	pass
func remove_upgrade(upgrade_entity):
	selected_robot.remove_upgrade(upgrade_entity.inst_id)
	energy_station.interacting_player.get_inventory(InventoryItem.ItemType.ROBOT_UPGRADE).add(upgrade_entity.upgrade.upgrade_item, 1)
	
	pass



func update_gui():
	if selected_robot != null:
		var robot_type = level.lookup_robot(selected_robot.pickup_item)
		robot_details.visible = true
		robot_details.get_node("RobotDescription/Control/RobotNameLabel").text =robot_type.get_type_name()
		robot_details.get_node("RobotDescription/Control2/RobotIcon").texture = robot_type.get_icon()
		
	else:
		robot_details.visible = false

		pass

	for child in robot_inv_list.get_children():
		child.queue_free()
	
	if energy_station != null:
		for robot in energy_station.robots:
			var robot_type = level.lookup_robot(robot.pickup_item)
			
			var new_tile = robot_list_tile.instantiate()
			new_tile.set_robot(robot, robot_type.get_icon(), robot_type.get_type_name())
			new_tile.set_parent_gui(self)
			
			robot_inv_list.add_child(new_tile)
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
	show_popup($RobotSelectionPopup)
	pass # Replace with function body.

func _on_place_robot_gui_button_pressed(item: InventoryItem, _amount):
	if level.place_robot_near_station(level.lookup_robot(item), energy_station):
		hide_popup($RobotSelectionPopup)
	pass # Replace with function body.

func show_popup(popup: Control):
	popup.show()
	$Blocking.show()
	pass

func hide_popup(popup: Control):
	popup.hide()
	$Blocking.hide()
	pass

func _on_close_popup_button_pressed():
	hide_popup($RobotSelectionPopup)
	hide_popup($AddUpgradesPopup)
	pass # Replace with function body.


func _on_add_upgrade_button_pressed():
	pass # Replace with function body.

@export var identify_camera : Camera2D
func _on_identify_robot_button_pressed():
	if identify_camera != null:
		hide()
		identify_camera.track_target(selected_robot)	
	
	pass # Replace with function body.

func on_identify_camera_finished_tracking():
	show()	
	pass

func _on_upgrade_robot_button_pressed():
	show_popup($AddUpgradesPopup)
	pass # Replace with function body.


func _on_inventory_robot_upgrade_gui_button_pressed(item, _amount):
	if energy_station.interacting_player.get_inventory(InventoryItem.ItemType.ROBOT_UPGRADE).remove(item, 1):
		selected_robot.add_upgrade(level.lookup_robot_upgrade(item))
	robot_upgrade_gui.update_gui()
	pass # Replace with function body.
