extends Node

# items don't get used up
@export var cheat_mode = true

@export var inventory_size = 5

# -1 means infinite stack size.
@export var stack_size = -1

var inventory = {}

var selected_crop = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func add_seed(crop: CropResource, amount : int):
	if inventory.has(crop):
		inventory[crop] += amount
	else:
		inventory[crop] = amount
		
	if selected_crop == null:
		selected_crop = inventory.keys().front()

func spend_seed(crop: CropResource, amount : int = 1):
	if inventory.has(crop):
		inventory[crop] -= amount
		
		if inventory[crop] <= 0:
			inventory.erase(crop)
			
			if selected_crop == crop:
				selected_crop = null
	else:
		print("warning: tried to spend seed that was not in inventory.")
	pass

func add_produce(crop: CropResource, amount : int):
	pass

func get_selected_item():
	return selected_crop

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
