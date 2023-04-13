extends Node
class_name InventoryComponent

# items don't get used up
@export var cheat_mode = true

@export var inventory_size = 5

# -1 means infinite stack size.
@export var stack_size = -1

signal inventory_modified

var inventory = {}
var selected = null
func add(item: Variant, amount : int):
	
	if inventory.has(item):
		inventory[item] += amount
	else:
		if inventory_size > inventory.size():
			inventory[item] = amount
		
	if selected == null:
		selected = inventory.keys().front()
	
	inventory_modified.emit()

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

func get_amount(item: Variant):
	if inventory.has(item):
		return inventory[item]
	else:
		return 0
	
func get_selected():
	return selected
