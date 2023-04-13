extends Panel

var buy_gui_scene = preload("res://Level/Trade Station/ts_buy_item_gui.tscn")
var sell_gui_scene = preload("res://Level/Trade Station/ts_sell_item_gui.tscn")

@export var buy_seed_parent : Control
@export var buy_fertiliser_parent : Control
@export var buy_robots_parent : Control
@export var sell_seed_parent : Control

@onready var level = get_node("/root/Level")

var trade_station : Node = null
signal opened_menu
signal closed_menu
func _ready():
	visibility_changed.connect(update_gui)
	generate_items(buy_seed_parent, buy_gui_scene, level.crops.map(func(c): return c.seed_item))
	generate_items(buy_fertiliser_parent, buy_gui_scene, level.fertilisers.map(func(c): return c.fertiliser_item))
#	generate_items(buy_robots_parent, buy_gui_scene, level.crops.map(func(c): return c.seed_item))
	generate_items(sell_seed_parent, sell_gui_scene, level.crops.map(func(c): return c.produce_item))

func generate_items(parent: Control, item_scene: PackedScene, items: Array):
	for item in items:
		var item_gui = item_scene.instantiate()
		parent.add_child(item_gui)
		item_gui.set_item(item)

func update_gui():
	for parent in [buy_seed_parent, buy_fertiliser_parent, buy_robots_parent, sell_seed_parent]:
		for child in parent.get_children():
			child.update_gui()

func set_trade_station(new_trade_station: Node):
	trade_station = new_trade_station

	for parent in [buy_seed_parent, buy_fertiliser_parent, buy_robots_parent, sell_seed_parent]:
		for child in parent.get_children():
			child.set_trade_station(trade_station)
	pass
