extends OverscreenGUI

@export var buy_seed_parent : Control
@export var buy_fertiliser_parent : Control
@export var buy_robots_parent : Control
@export var sell_parent : Control

var buy_gui_scene = preload("res://Level/Trade Station/ts_buy_item_gui.tscn")
var sell_gui_scene = preload("res://Level/Trade Station/ts_sell_item_gui.tscn")

var trade_station : Node = null

@onready var level = get_node("/root/Level")
@onready var currency_manager = get_node("/root/Level/CurrencyManager")

func _ready():
	visibility_changed.connect(update_gui)
	generate_items(buy_seed_parent, buy_gui_scene, level.crops.map(func(c): return c.seed_item))
	generate_items(buy_fertiliser_parent, buy_gui_scene, level.fertilisers.map(func(c): return c.fertiliser_item))
	sell_parent.item_selected.connect(sell)

func sell(item, amount):
	currency_manager.sell(trade_station.get_interacting_player(), item , amount)	

func generate_items(parent: Control, item_scene: PackedScene, items: Array):
	for item in items:
		var item_gui = item_scene.instantiate()
		parent.add_child(item_gui)
		item_gui.set_item(item)

func update_gui():
	for parent in [buy_seed_parent, buy_fertiliser_parent, buy_robots_parent, sell_parent]:
		for child in parent.get_children():
			child.update_gui()
	
	for n in get_tree().get_nodes_in_group("ts_sell_item"):
		n.set_trade_station(trade_station)
			
func set_trade_station(new_trade_station: Node):
	
	trade_station = new_trade_station

	for parent in [buy_seed_parent, buy_fertiliser_parent, buy_robots_parent]:
		for child in parent.get_children():
			if child.has_method("set_trade_station"):
				child.set_trade_station(trade_station)
	for child in sell_parent.get_children().reduce(func(a, b): return a + b.get_children(), []):
		
		if child.has_method("set_trade_station"):
			child.set_trade_station(trade_station)

func get_trade_station():
	return trade_station
