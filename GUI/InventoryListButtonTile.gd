extends HBoxContainer

var item : InventoryItem
var amount : int

func set_item(new_item: InventoryItem, new_amount: int) -> void:
	item = new_item
	amount = new_amount

	$AmountLabel.text = "%dx" % amount
	$NameLabel.text = new_item.item_name

func connect_to_button(callback: Callable) -> void:
	$Button.pressed.connect(func(): callback.call(item, amount))

