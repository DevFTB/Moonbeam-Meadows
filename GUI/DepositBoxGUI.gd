extends Control
signal opened_menu
signal closed_menu

var deposit_box : DepositBox
var inventory_button_list = preload("res://GUI/inventory_button_list.tscn")
func set_deposit_box(new_deposit_box : Node2D) -> void:
	deposit_box = new_deposit_box
	
	for child in $InventoryButtonListParent.get_children():
		child.queue_free()
	
	for it in deposit_box.item_types:
		var new_button_list = inventory_button_list.instantiate()
		new_button_list.set_inventory(deposit_box.inventories.filter(func(x): return x.inventory_type == it).front())
		$InventoryButtonListParent.add_child(new_button_list)
		new_button_list.button_pressed.connect(on_item_selected)
	pass

func on_item_selected(item : InventoryItem, amount :int) -> void:
	deposit_box.transfer_to_player(item, amount)
	pass
	
func can_show():
	return not get_parent().get_children().filter(func(x): return x != self).any(func(x): return x.visible)
