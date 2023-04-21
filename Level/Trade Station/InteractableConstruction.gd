extends Node2D
class_name InteractableConstruction

@export var gui : Control

var interacting_player : Player = null
func _ready():
	$InteractArea.body_entered.connect(_on_interact_area_body_entered)
	$InteractArea.body_exited.connect(_on_interact_area_body_exited)
	pass
func get_interacting_player() -> Player:
	return interacting_player	

func _on_interact_area_body_entered(body:Node2D):
	if body.is_in_group("player"):
		interacting_player = body

		set_gui_owner()
	pass # Replace with function body.

func _on_interact_area_body_exited(body:Node2D):
	if body == interacting_player:
		interacting_player.unfreeze()
		interacting_player = null
		gui.hide()
	pass # Replace with function body.

func _input(event):
	if event.is_action_pressed("interact") and interacting_player != null:
		if gui.can_show():
			gui.visible = not gui.visible
			if gui.visible:
				interacting_player.freeze() 
			else:
				interacting_player.unfreeze()
	pass

func set_gui_owner():
	pass
