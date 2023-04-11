extends Node

# items don't get used up
@export var cheat_mode = true

@export var inventory_size = 5

# -1 means infinite stack size.
@export var stack_size = -1

var seed_inventory = {}
var produce_inventory = {}

var selected_crop = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func add_seed(crop: CropResource, amount : int):
	if seed_inventory.has(crop):
		seed_inventory[crop] += amount
	else:
		seed_inventory[crop] = amount
		
	if selected_crop == null:
		selected_crop = seed_inventory.keys().front()

func spend_seed(crop: CropResource, amount : int = 1):
	if seed_inventory.has(crop):
		seed_inventory[crop] -= amount
		
		if seed_inventory[crop] <= 0:
			seed_inventory.erase(crop)
			
			if selected_crop == crop:
				selected_crop = null
	else:
		print("warning: tried to spend seed that was not in seed inventory.")
	pass

func add_produce(crop: CropResource, amount : int):
	if produce_inventory.has(crop):
		produce_inventory[crop] += amount
	else:
		produce_inventory[crop] = amount
		
	print("added %d amount of %s" % [amount, crop.crop_name])
	pass

func spend_produce(crop: CropResource, amount : int = 1):
	if produce_inventory.has(crop):
		produce_inventory[crop] -= amount
		
		if produce_inventory[crop] <= 0:
			produce_inventory.erase(crop)
			
	else:
		print("warning: tried to spend seed that was not in produce inventory.")
	pass

func get_selected_item():
	return selected_crop

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
