extends Label

@export var inventory : Node

# Called when the node enters the scene tree for the first time.
func _ready():
	inventory.inventory_modified.connect(update_text)
	pass # Replace with function body.


func update_text():
	var new_text = ""
	for item in inventory.inventory.keys():
		new_text += "%dx %s \n" % [inventory.inventory[item], item.get_display_name()]

	text = new_text
	



func _on_phone_gui_opened_menu():
	update_text()
	pass # Replace with function body.