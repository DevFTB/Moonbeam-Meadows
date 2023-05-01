extends OverscreenGUI

# The GUI for the deposit box

@export var deposit_box_list : Control
@export var player_inventory_list: Control
@export var add_from_inventory_panel : PanelContainer

var adding = false
var deposit_box : DepositBox
var inventory_button_list = preload("res://GUI/inventory_button_list.tscn")

@onready var default_size = size
@onready var expanded_size = Vector2(size.x * 1.5, size.y)
@onready var offset = size.x * 0.25

func set_deposit_box(new_deposit_box : Node2D) -> void:
	deposit_box = new_deposit_box
	
	deposit_box_list.set_inventories(deposit_box.inventories.values())
	if not deposit_box_list.item_selected.is_connected(_on_item_selected_to_player):
		deposit_box_list.item_selected.connect(_on_item_selected_to_player)

	player_inventory_list.set_inventories(deposit_box.interacting_player.inventories.filter(func(inv): return deposit_box.item_types.has(inv.inventory_type)))

	if not player_inventory_list.item_selected.is_connected(_on_item_selected_to_box):
		player_inventory_list.item_selected.connect(_on_item_selected_to_box)
	pass

func _on_item_selected_to_player(item : InventoryItem, amount :int) -> void:
	deposit_box.transfer_to_player(item, amount)
	pass

func _on_item_selected_to_box(item : InventoryItem, amount :int) -> void:
	deposit_box.transfer_to_box(item, amount)
	pass
func _on_add_from_inventory_button_pressed() -> void:
	if not adding:
		set_size(expanded_size)
		position.x -= offset
		add_from_inventory_panel.show()
		adding = true
	else:
		set_size(default_size)
		position.x += offset
		add_from_inventory_panel.hide()
		adding = false
	
	pass
	
