extends Control
const ItemType = preload("res://Inventory/InventoryItem.gd").ItemType

@export var item : InventoryItem = null
@export var item_type: ItemType = ItemType.PRODUCE
@export var multisell_delay = 0.7
@export var multisell_rate = 10.0

var multisell = false
var multisell_timer = 0.0
var multisell_amount = 0
var pressed = false
var max_amount = 1

@onready var currency_manager : Node = get_node("/root/Level/CurrencyManager")
var trade_station : Node = null

var player_inventory : Node 

func _ready():
	pass

func _process(delta):
	if multisell:
		multisell_timer += delta
		if multisell_timer > 1.0 / multisell_rate:
			multisell_timer = 0.0
			if multisell_amount < max_amount:
				multisell_amount += 1
				$VBoxContainer/SellButton.text = "Sell " + str(multisell_amount)
			pass
	pass

func set_item(new_item: InventoryItem):
	self.item = new_item
	$IconTextureRect.texture = item.item_icon
	$NameLabel.text = item.item_name
	$VBoxContainer/HBoxContainer/CostLabel.text = str(item.sell_price)

func start_multisell():
	print("start multisell")

	if pressed:
		multisell = true
		multisell_timer = 0
		max_amount = player_inventory.get_amount(item)
	pass

func _on_sell_button_pressed():
	if not multisell:
		currency_manager.sell(trade_station.get_interacting_player(), item, 1)	
	pass # Replace with function body.


func _on_sell_button_button_down():
	pressed = true
	get_tree().create_timer(multisell_delay).timeout.connect(start_multisell)
	pass # Replace with function body.


func _on_sell_button_button_up():
	pressed = false
	if multisell:
		print("multisell %d" % multisell_amount)
		currency_manager.sell(trade_station.get_interacting_player(), item ,multisell_amount)	
		multisell = false
		$VBoxContainer/SellButton.text = "Sell 1"
		
	pass # Replace with function body.

func update_gui():
	$VBoxContainer/SellButton.disabled = player_inventory.get_amount(item) == 0
	pass

func set_trade_station(new_trade_station: Node):
	trade_station = new_trade_station
	var interacting_player = trade_station.get_interacting_player()
	if interacting_player != null:
		player_inventory = interacting_player.get_inventory(item_type)
		if not player_inventory.inventory_modified.is_connected(update_gui):
			player_inventory.inventory_modified.connect(update_gui)
	update_gui()
	pass

