extends VBoxContainer

var Player = preload("res://Player/Player.gd")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_player_tool_changed(new_tool):
	var new_text = ""
	match(new_tool):
		Player.Tool.TILL:
			new_text = "Tiller"
			pass
		Player.Tool.HARVEST:
			new_text = "Harvester"
			pass
		Player.Tool.WATER:
			new_text = "Waterer"
			pass
		Player.Tool.FERTILISE:
			new_text = "Fertilising Machine"
			pass
		Player.Tool.PLANT:
			new_text = "Planter"
			pass
	$CurrentToolText.text = new_text
	pass # Replace with function body.
