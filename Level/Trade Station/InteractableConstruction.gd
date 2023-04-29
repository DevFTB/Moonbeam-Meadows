extends Node2D
class_name InteractableConstruction

## A building in the world that opens a GUI when interacted with by the player in range

## The GUI to open when interacted with
@export var gui : Control

## The player that intearcted with this object
var interacting_player : Player = null

func _ready():
	$InteractArea.body_entered.connect(_on_interact_area_body_entered)
	$InteractArea.body_exited.connect(_on_interact_area_body_exited)
	pass

func _input(event):
	if event.is_action_pressed("interact") and interacting_player != null:
		if gui != null and gui.can_show():
			gui.visible = not gui.visible
			if gui.visible:
				interacting_player.freeze() 
			else:
				interacting_player.unfreeze()
	pass

func set_gui_owner() -> void:
	pass

func get_interacting_player() -> Player:
	return interacting_player	

func _on_interact_area_body_entered(body:Node2D):
	if body.is_in_group("player"):
		interacting_player = body

		set_gui_owner()
	

func _on_interact_area_body_exited(body:Node2D):
	if body == interacting_player:
		interacting_player.unfreeze()
		interacting_player = null
		if gui != null:
			gui.hide()
	

