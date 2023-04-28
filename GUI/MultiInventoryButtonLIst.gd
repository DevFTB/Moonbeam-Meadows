extends VBoxContainer

@export var inventories = []
var _inventories = {}

@export var interactable = true

var inventory_button_list = preload("res://GUI/inventory_button_list.tscn")

signal item_selected(item : InventoryItem, amount : int)

func _ready():
	set_inventories(inventories.map(func(x): return get_node(x)))
func update_gui():
	for child in get_children():
		remove_child(child)
		child.queue_free()

	for it in _inventories.keys():
		var inventory = _inventories[it]
		var new_button_list = inventory_button_list.instantiate() as Control
		new_button_list.interactable = interactable
		new_button_list.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
		new_button_list.set_inventory(inventory)
		new_button_list.button_pressed.connect(on_item_selected)
		add_child(new_button_list)

func set_inventories(new_inventories : Array):
	for inv in new_inventories:
		_inventories[inv.inventory_type] = inv
	update_gui()

func on_item_selected(item : InventoryItem, amount :int) -> void:
	item_selected.emit(item, amount)
	pass
