extends Control 

signal button_pressed(item: InventoryItem, amount :int)

@export var _inventory : InventoryComponent
@export var interactable = true

@export var list_tile_scene = preload("res://GUI/item_list_button_tile.tscn")
@export var button_text = "Place"

var inventory : InventoryComponent
var on_build_callback

func _ready():
	if _inventory != null:
		set_inventory(_inventory)

func set_inventory(new_inventory : InventoryComponent):
	inventory = new_inventory
	if not inventory.inventory_modified.is_connected(_on_inventory_modified):
		inventory.inventory_modified.connect(_on_inventory_modified)
	update_gui()
	pass

func set_button_text(new_text : String):
	button_text = new_text
	pass

func update_gui():
	for child in $Buttons.get_children():
		child.queue_free()

	if inventory.get_amount_of_unique_items() == 0: hide()
	else: show()

	$Label.text = InventoryItem.type_to_string(inventory.inventory_type) + str(" CAPACITY:  ", inventory.get_amount_of_items(), " / ", inventory.inventory_size)
	
	for item in inventory.inventory.keys():
		var list_tile = list_tile_scene.instantiate()
		if list_tile.has_method("set_button_text"):
			list_tile.set_button_text(button_text)
		list_tile.set_item(item, inventory.inventory[item])
		if list_tile.has_method("connect_to_button"):
			list_tile.connect_to_button(_on_button_pressed)
		list_tile.interactable = interactable
		$Buttons.add_child(list_tile)
		
		if on_build_callback != null:
			on_build_callback.call(list_tile)
	pass

func _on_inventory_modified():
	update_gui()


func _on_button_pressed(item: InventoryItem, amount: int):
	button_pressed.emit(item, amount)
	pass

