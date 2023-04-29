extends VBoxContainer

@export var inventory : InventoryComponent
@export var interactable = true

@export var list_tile_scene = preload("res://GUI/item_list_button_tile.tscn")
@export var button_text = "Place"
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

	if inventory.get_amount_of_unique_items() == 0: hide()
	else: show()

	for item in inventory.inventory.keys():
		var list_tile = list_tile_scene.instantiate()
		if list_tile.has_method("set_button_text"):
			list_tile.set_button_text(button_text)
		list_tile.set_item(item, inventory.inventory[item])
		if list_tile.has_method("connect_to_button"):
			list_tile.connect_to_button(on_button_pressed)
		list_tile.interactable = interactable
		add_child(list_tile)

		configure_tile(list_tile)
	pass

func configure_tile(new_tile):
	pass

func on_button_pressed(item: InventoryItem, amount: int):
	button_pressed.emit(item, amount)
	pass

func set_button_text(new_text : String):
	button_text = new_text
	pass
