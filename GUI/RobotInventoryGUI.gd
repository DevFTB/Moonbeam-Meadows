extends VBoxContainer

@export var inventory : InventoryComponent

var list_tile_scene = preload("res://GUI/inventory_robot_list_tile.tscn")

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
	get_node("/root/Level").place_robot_near_player(robot)
	pass
