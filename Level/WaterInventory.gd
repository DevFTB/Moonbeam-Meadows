extends InventoryComponent
class_name WaterInventory

const water = preload("res://Level/WaterStation/item_water.tres")

@export var starting_water : int = 10

var water_amount:
	get: 
		return get_amount_of_items()

func _ready():
	add_water(starting_water)

func add_water(amount: int) -> bool:
	return add(water, amount)
	
func remove_water(amount: int) -> bool:
	return remove(water, amount)
