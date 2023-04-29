extends Control

@export var amount_label : Label
@export var name_label : Label
@export var action_button : Button
@export var icon_texture_rect : TextureRect
@export var interactable : bool = true:
	set(value):
		interactable = value
		action_button.visible = interactable

var item : InventoryItem
var amount : int

func set_item(new_item: InventoryItem, new_amount: int) -> void:
	item = new_item
	amount = new_amount

	amount_label.text = "%dx" % amount
	name_label.text = new_item.item_name

	icon_texture_rect.texture = new_item.item_icon

func connect_to_button(callback: Callable) -> void:
	action_button.pressed.connect(func(): callback.call(item, amount))

func set_button_text(new_text: String) -> void:
	action_button.text = new_text