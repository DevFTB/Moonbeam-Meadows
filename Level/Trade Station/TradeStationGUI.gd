extends Panel

var crop_buy_gui_scene = preload("res://Level/Trade Station/ts_buy_item_gui.tscn")
var crop_sell_gui_scene = preload("res://Level/Trade Station/ts_sell_item_gui.tscn")

@export var buy_seed_parent : Control
@export var sell_seed_parent : Control

@onready var level = get_node("/root/Level")

var trade_station : Node = null

func _ready():
	visibility_changed.connect(update_gui)
	for seed_item in level.crops.map(func(c): return c.seed_item):
		var buy_item_gui = crop_buy_gui_scene.instantiate()
		buy_seed_parent.add_child(buy_item_gui)
		buy_item_gui.set_item(seed_item)
	
	for produce_item in level.crops.map(func(c): return c.produce_item):
		var sell_item_gui = crop_sell_gui_scene.instantiate()
		sell_seed_parent.add_child(sell_item_gui)
		sell_item_gui.set_item(produce_item)

func update_gui():
	for child in buy_seed_parent.get_children():
		child.update_gui()

func set_trade_station(new_trade_station: Node):
	trade_station = new_trade_station

	for child in buy_seed_parent.get_children():
		child.set_trade_station(new_trade_station)

	for child in sell_seed_parent.get_children():
		child.set_trade_station(new_trade_station)
	pass
