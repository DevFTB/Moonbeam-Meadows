extends VBoxContainer

@export var inventory : InventoryComponent

var list_tile_scene = preload("res://GUI/item_list_button_tile.tscn")

signal button_pressed(item: InventoryItem, amount :int)
func set_inventory(new_inventory : InventoryComponent):
	inventory = new_inventory

	if not inventory.inventory_modified.is_connected(_on_inventory_modified):
		inventory.inventory_modified.connect(_on_inventory_modified)
	update_gui()
	pass
func _ready():
	set_inventory(inventory)

func _on_inventory_modified():
	update_gui()

func update_gui():
	for child in get_children():
		child.queue_free()

	for item in inventory.inventory.keys():
		var list_tile = list_tile_scene.instantiate()
		list_tile.set_item(item, inventory.inventory[item])
		list_tile.connect_to_button(on_button_pressed)
		add_child(list_tile)
	pass

func on_button_pressed(item: InventoryItem, amount: int):
	button_pressed.emit(item, amount)
	pass