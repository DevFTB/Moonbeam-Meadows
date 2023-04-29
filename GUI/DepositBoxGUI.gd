extends OverscreenGUI

var deposit_box : DepositBox
var inventory_button_list = preload("res://GUI/inventory_button_list.tscn")

@export var inventory_button_list_parent : Control

func set_deposit_box(new_deposit_box : Node2D) -> void:
	deposit_box = new_deposit_box
	
	for child in inventory_button_list_parent.get_children():
		child.queue_free()
	
	for it in deposit_box.item_types:
		var inventory = deposit_box.get_inventory(it)
		if inventory.get_amount_of_unique_items()  > 0 :
			var new_button_list = inventory_button_list.instantiate() as Control
			new_button_list.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
			new_button_list.set_inventory(deposit_box.get_inventory(it))
			inventory_button_list_parent.add_child(new_button_list)
			new_button_list.button_pressed.connect(on_item_selected)
	pass

func on_item_selected(item : InventoryItem, amount :int) -> void:
	deposit_box.transfer_to_player(item, amount)
	pass
	