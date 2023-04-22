extends VBoxContainer

@export var inventory : InventoryComponent

var energy_station = null
var list_tile_scene = preload("res://GUI/inventory_robot_list_tile.tscn")

signal placed_robot()

func _ready():
	inventory.inventory_modified.connect(_on_inventory_modified)
	update_gui()

func _on_inventory_modified():
	update_gui()

func update_gui():
	for child in get_children():
		child.queue_free()

	for item in inventory.inventory.keys():
		var robot_resource = get_node("/root/Level").lookup_robot(item)
		var list_tile = list_tile_scene.instantiate()
		list_tile.set_robot(robot_resource, inventory.inventory[item])
		list_tile.connect_to_place_button(on_place_button_pressed)
		add_child(list_tile)
	pass


func on_place_button_pressed(robot: RobotResource):
	if get_node("/root/Level").place_robot_near_station(robot, energy_station):
		placed_robot.emit()

	pass


func _on_energy_station_gui_changed_energy_station(new_energy_station:EnergyStation):
	energy_station = new_energy_station
	pass # Replace with function body.
