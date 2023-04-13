extends Node2D

@export var trade_station_gui : Control

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
		trade_station_gui.set_trade_station(self)
	pass # Replace with function body.

func _on_interact_area_body_exited(body:Node2D):
	if body == interacting_player:
		interacting_player = null
		trade_station_gui.hide()
	pass # Replace with function body.

func _input(event):
	if event.is_action_pressed("interact") and interacting_player != null and not interacting_player.frozen:
		trade_station_gui.visible = not trade_station_gui.visible
	pass
