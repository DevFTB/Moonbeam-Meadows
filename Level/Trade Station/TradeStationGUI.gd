extends Panel

var item_gui_scene = preload("res://Level/Trade Station/ts_buy_item_gui.tscn")

@export var buy_seed_parent : Control

@onready var level = get_node("/root/Level")

var trade_station : Node = null

func _ready():
	visibility_changed.connect(update_gui)
	for crop in level.crops:
		var item_gui = item_gui_scene.instantiate()

		buy_seed_parent.add_child(item_gui)

		item_gui.set_crop(crop)
		item_gui.set_trade_station(trade_station)



func update_gui():
	for child in buy_seed_parent.get_children():
		child.update_gui()

func set_trade_station(new_trade_station: Node):
	trade_station = new_trade_station

	for child in buy_seed_parent.get_children():
		child.set_trade_station(new_trade_station)

	pass
