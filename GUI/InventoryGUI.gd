extends Label

@export var inventory : Node

func _ready():
	inventory.inventory_modified.connect(update_text)
	

func update_text():
	var new_text = ""
	for item in inventory.inventory.keys():
		new_text += "%dx %s \n" % [inventory.inventory[item], item.item_name]

	text = new_text
