extends OverscreenGUI

signal changed_energy_station(energy_station: EnergyStation)
signal changed_selected_robot(robot: Robot)

@export var path_editing_gui : Control
@export var robot_upgrade_gui : Control

@export var robot_details : Control
@export var robot_inv_list : Control
@export var add_from_inventory_button : Button
@export var robot_list_tile = preload("res://Level/Energy Station/robot_list_tile.tscn")
@export var identify_camera : Camera2D
@export var power_button : Button

var selected_robot = null
var energy_station = null

@onready var level = get_node("/root/Level")
# Called when the node enters the scene tree for the first time.
func _ready():
	visibility_changed.connect(
	func(): if visible: 
		_hide_popup($RobotSelectionPopup)
		_hide_popup($AddUpgradesPopup)
	)
	identify_camera.finished_tracking.connect(_on_identify_camera_finished_tracking)
	path_editing_gui.finished_editing.connect(end_editing)
	update_gui()

func _process(delta):
	if selected_robot != null:
		update_power_button()

func set_energy_station(new_energy_station: EnergyStation):
	energy_station = new_energy_station
	changed_energy_station.emit(energy_station)
	if not energy_station.robot_removed.is_connected(_on_remove_robot):
		energy_station.robot_removed.connect(_on_remove_robot)

	update_gui()
	pass

func update_gui():
	# updates the robot description
	if selected_robot != null:
		var robot_type = level.lookup_robot(selected_robot.pickup_item)
		robot_details.visible = true
		robot_details.get_node("RobotDescription/Control/RobotNameLabel").text =robot_type.get_type_name()
		robot_details.get_node("RobotDescription/Control2/RobotIcon").texture = robot_type.get_icon()
		
	else:
		robot_details.visible = false

	for child in robot_inv_list.get_children():
		child.queue_free()

	if energy_station != null:
		if energy_station.interacting_player:
			add_from_inventory_button.disabled = energy_station.interacting_player.get_inventory(InventoryItem.ItemType.ROBOT).get_amount_of_items() == 0

		for robot in energy_station.robots:
			var robot_type = level.lookup_robot(robot.pickup_item)
			
			var new_tile = robot_list_tile.instantiate()
			new_tile.set_robot(robot, robot_type.get_icon(), robot_type.get_type_name())
			new_tile.set_parent_gui(self)
			
			robot_inv_list.add_child(new_tile)
	pass


func remove_upgrade(upgrade_entity):
	selected_robot.remove_upgrade(upgrade_entity.inst_id)
	energy_station.interacting_player.get_inventory(InventoryItem.ItemType.ROBOT_UPGRADE).add(upgrade_entity.upgrade.upgrade_item, 1)
	pass

func end_editing():
	visible = true
	energy_station.hide_area()
	pass

func is_active():
	return visible or $AddUpgradesPopup.visible or $RobotSelectionPopup.visible or path_editing_gui.visible

func can_show():
	return super.can_show() and not path_editing_gui.visible


func _show_popup(popup: Control):
	popup.show()
	$Blocking.show()

func _hide_popup(popup: Control):
	popup.visible = false
	$Blocking.hide()

func _on_add_robot_button_pressed():
	_show_popup($RobotSelectionPopup)
	
func _on_place_robot_gui_button_pressed(item: InventoryItem, _amount):
	if level.place_robot_near_station(level.lookup_robot(item), energy_station):
		_hide_popup($RobotSelectionPopup)
	
func hide_all():
	_hide_popup($RobotSelectionPopup)
	_hide_popup($AddUpgradesPopup)
	super.hide_all()
func _on_robot_selected(robot):
	selected_robot = robot
	changed_selected_robot.emit(selected_robot)
	update_gui()
	pass

func _on_upgrade_robot_button_pressed():
	_show_popup($AddUpgradesPopup)
	
func _on_inventory_robot_upgrade_gui_button_pressed(item, _amount):
	if energy_station.interacting_player.get_inventory(InventoryItem.ItemType.ROBOT_UPGRADE).remove(item, 1):
		selected_robot.add_upgrade(level.lookup_robot_upgrade(item))
	robot_upgrade_gui.update_gui()
	
func _on_remove_robot(_robot: Robot):
	selected_robot = null


func _on_close_popup_button_pressed():
	_hide_popup($RobotSelectionPopup)
	_hide_popup($AddUpgradesPopup)
	
func _on_add_upgrade_button_pressed():
	pass	

func _on_edit_path_button_pressed():
	visible = false
	path_editing_gui.start_editing(selected_robot, energy_station)
	energy_station.show_area()
	
func _on_identify_robot_button_pressed():
	if identify_camera != null:
		hide()
		identify_camera.track_target(selected_robot)	
	
func _on_identify_camera_finished_tracking():
	show()	


func _on_power_button_pressed():
	if selected_robot != null:
		selected_robot.toggle_power()
	pass # Replace with function body.

func update_power_button():
	power_button.text = " Turn Off " if selected_robot.powered else " Turn On "
	if not selected_robot.powered:
		power_button.disabled = not selected_robot.can_power_on() 
	else: 
		power_button.disabled = false
