extends Label

@export var inventory : Node

# Called when the node enters the scene tree for the first time.
func _ready():
	inventory.inventory_modified.connect(update_text)
	pass # Replace with function body.


func update_text():
	var new_text = ""
	for item in inventory.inventory.keys():
		new_text += "%dx %s \n" % [inventory.inventory[item], item.item_name]

	text = new_text