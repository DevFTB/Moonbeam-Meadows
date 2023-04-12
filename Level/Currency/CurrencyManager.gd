extends Node

@export var starting_amount = 10

signal currency_changed(new_value)

var currency = 0

func _ready():
	currency = starting_amount
	currency_changed.emit(currency)
	pass

func spend_currency(amount):
	if currency >= amount:
		currency -= amount
		currency_changed.emit(currency)
		return true
	else:
		return false

func gain_currency(amount):
	currency += amount
	pass