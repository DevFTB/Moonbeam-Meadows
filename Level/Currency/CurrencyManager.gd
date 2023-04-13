extends Node

@export var starting_amount = 10

signal currency_changed(new_value)

var currency = 0

func _ready():
	currency = starting_amount
	currency_changed.emit(currency)
	pass

func get_currency():
	return currency
func buy(player:Player, item: Variant, amount: int):
	if spend_currency(item.get_buy_price() * amount):
		print("spent %d currency" % (item.get_buy_price() * amount))
		player.get_inventory(item.get_type()).add(item, amount)
		return true
	else:
		return false
		
func sell(player: Player, item: Variant, amount: int):
	if player.get_inventory(item.get_type()).remove(item, amount):
		add_currency(item.get_sell_price() * amount)
	pass


func spend_currency(amount):
	if currency >= amount:
		currency -= amount
		currency_changed.emit(currency)
		return true
	else:
		return false

func add_currency(amount):
	currency += amount
	currency_changed.emit(currency)
	pass
