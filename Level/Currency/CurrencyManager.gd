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

func buy(player:Player, crop: CropResource, amount: int):
	if spend_currency(crop.seed_cost * amount):
		print("spent %d currency" % (crop.seed_cost * amount))
		player.get_node("SeedInventory").add(crop, amount)
		return true
	else:
		return false
		
func sell_crop(player: Player, crop: CropResource, amount: int):
	if player.get_node("ProduceInventory").remove(crop, amount):
		add_currency(crop.produce_cost * amount)
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
