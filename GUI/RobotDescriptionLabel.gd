extends RichTextLabel

@export var template = "status: [color=%s]%s[/color]

Energy: %d / %d 
Inventory: %d / %d
%s
%s"
var robot = null

@onready var level = get_node("/root/Level")

func update_gui():
	if robot != null:
		text = format_description()
	else:
		text = ""
		
func format_description():
	var status_color = "green" if robot.powered else "red"
	var status = "Powered" if robot.powered else "Unpowered"
	var total_inventory_capacity = robot.inventories.reduce(func(a,b): return a + b.inventory_size, 0 )
	var total_inventory_items = robot.inventories.reduce(func(a,b): return a + b.get_amount_of_items(), 0 )
	return template % [status_color, status, robot.energy, robot.energy_capacity.get_value(), total_inventory_items, total_inventory_capacity, robot.get_specific_description(), level.lookup_robot(robot.pickup_item).robot_description]

func _on_timer_timeout():
	update_gui()

func _on_energy_station_gui_changed_selected_robot(new_robot:Robot):
	robot = new_robot
	text = format_description()
	
