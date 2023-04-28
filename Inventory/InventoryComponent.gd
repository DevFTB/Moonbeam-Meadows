extends Node
class_name InventoryComponent

# max amount of items in the inventory
@export var inventory_size = 5

# items don't get used up
@export var cheat_mode = false

@export var inventory_type : InventoryItem.ItemType = InventoryItem.ItemType.PRODUCE

signal inventory_modified

@export var inventory = {}
var selected = null

func add(item: Variant, amount : int) -> bool:
	if inventory.has(item):
		if amount + get_amount_of_items() > inventory_size:
			return false
		else:
			inventory[item] += amount
	else:
		if inventory_size - get_amount_of_items() >= amount:
			inventory[item] = amount
		else:
			return false
		
	if selected == null:
		selected = inventory.keys().front()
	
	inventory_modified.emit()
	return true

func remove(item: Variant, amount : int = 1):
	if inventory.has(item):
		if inventory[item] >= amount or cheat_mode:
			inventory[item] -= amount
			if inventory[item] <= 0:
				inventory.erase(item)
				
				if selected == item:
					selected = null
			inventory_modified.emit()
			return true
		else:
			print("warning: tried to remove more than was in inventory.")

	else:
		print("warning: tried to spend item that was not in inventory.")

	return false

func has_item(item: Variant):
	return inventory.has(item)

func get_amount(item: Variant):
	if inventory.has(item):
		return inventory[item]
	else:
		return 0

func get_amount_of_unique_items():
	return inventory.size()
func get_amount_of_items():
	return inventory.values().reduce(func(a, b): return a + b,0)
	
func get_selected():
	return selected

func get_available_capacity():
	return inventory_size - inventory.values().reduce(func(a, b): return a + b,0)