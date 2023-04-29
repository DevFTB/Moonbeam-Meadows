extends Node
class_name InventoryComponent

signal inventory_modified

# max amount of items in the inventory
@export var inventory_size = 5
# items don't get used up
@export var cheat_mode = false
@export var inventory_type : InventoryItem.ItemType = InventoryItem.ItemType.PRODUCE
@export var inventory = {}

var selected = null
## adds an item to the inventory of the player. the operation will not be partial, meaning that if the inventory is full, the request will not be added.
## returns true if the item was added, false if not.
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

## removes an item from the inventory of the player. the operation will not be partial, meaning that if the inventory does not contain the item, the request will not be completed. 
func remove(item: Variant, amount : int = 1) -> bool:
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
			push_warning("warning: tried to remove more than was in inventory.")

	else:
		push_warning("warning: tried to spend item that was not in inventory.")

	return false

func has_item(item: Variant) -> bool:
	return inventory.has(item)

## returns the amount of a specifc item in the inventory
func get_amount(item: Variant)-> int:
	if inventory.has(item):
		return inventory[item]
	else:
		return 0
## returns the amount of different items in the inventory
func get_amount_of_unique_items() -> int:
	return inventory.size()

## returns the amount of items in the inventory
func get_amount_of_items() -> int:
	return inventory.values().reduce(func(a, b): return a + b,0)
	
func get_selected() -> InventoryItem:
	return selected

## returns the amount of free space in the inventory
func get_available_capacity() -> int:
	return inventory_size - inventory.values().reduce(func(a, b): return a + b,0)