extends InventoryComponent
class_name WaterInventory

const water = preload("res://Level/WaterStation/item_water.tres")

signal depeleted 

@export var starting_water : int = 10

var water_amount:
	get: 
		return get_amount_of_items()

func _ready():
	add_water(starting_water)

func add_water(amount: int) -> bool:
	return add(water, amount)
	
func remove_water(amount: int) -> bool:
	var success  = remove(water, amount)
	if success and get_amount_of_items() == 0:
		depeleted.emit()
	return success
