extends Label

@export var currency_manager : Node

func _ready():
	currency_manager.currency_changed.connect(update_currency)

func update_currency(new_value: int):
	text = str(new_value)
