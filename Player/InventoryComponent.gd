extends Node

# items don't get used up
@export var cheat_mode = true

@export var inventory_size = 5

# -1 means infinite stack size.
@export var stack_size = -1

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

func remove(item: Variant, amount : int = 1):
	if inventory.has(item):
		inventory[item] -= amount
		
		if inventory[item] <= 0:
			inventory.erase(item)
			
			if selected == item:
				selected = null
	else:
		print("warning: tried to spend item that was not in seed inventory.")
	pass
	
func get_selected():
	return selected
