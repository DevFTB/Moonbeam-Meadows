extends Control
const ItemType = preload("res://Inventory/InventoryItem.gd").ItemType

## A item tile in the trade station that allows the player to sell items or multisell items

@export var item : InventoryItem = null

## The delay before the item starts to be sold multiple times
@export var multisell_delay = 0.7

## The rate at which the item is sold multiple times
@export var multisell_rate = 10.0

@export var icon_texture_rect : TextureRect
@export var name_label : Label
@export var cost_label : Label
@export var sell_button : Button

@export var amount_label :Label

var multisell = false
var multisell_timer = 0.0
var multisell_amount = 0
var pressed = false
var max_amount = 1
var interactable = true
var player_inventory : Node 
var interact_callback = null

@onready var currency_manager : Node = get_node("/root/Level/CurrencyManager")
var trade_station : Node2D
func _ready():
	pass

func _process(delta):
	if multisell:
		multisell_timer += delta
		if multisell_timer > 1.0 / multisell_rate:
			multisell_timer = 0.0
			if multisell_amount < max_amount:
				multisell_amount += 1
				sell_button.text = "Sell " + str(multisell_amount)
			pass
	pass

func set_item(new_item: InventoryItem, _amount):
	self.item = new_item
	icon_texture_rect.texture = item.item_icon
	name_label.text = item.item_name
	cost_label.text = str(item.sell_price)

func start_multisell():
	if pressed:
		
		multisell = true
		multisell_timer = 0
		multisell_amount = 0
		max_amount = player_inventory.get_amount(item)
	pass

func update_gui():
	if player_inventory != null:
		sell_button.disabled = player_inventory.get_amount(item) == 0
	pass

func set_trade_station(new_trade_station: Node):
	
	if new_trade_station != null:
		
		trade_station = new_trade_station
		var interacting_player = trade_station.get_interacting_player()
		if interacting_player != null:
			player_inventory = interacting_player.get_inventory(item.item_type)
			if player_inventory != null:
				if not player_inventory.inventory_modified.is_connected(update_gui):
					player_inventory.inventory_modified.connect(update_gui)
				amount_label.text = str(player_inventory.get_amount(item))
		update_gui()
	pass

func connect_to_button(callable: Callable):
	interact_callback = callable

func _on_sell_button_pressed():
	if not multisell:
		
		#currency_manager.sell(trade_station.get_interacting_player(), item, 1)	
		if interact_callback != null:
			interact_callback.call(item,1)
	


func _on_sell_button_button_down():
	pressed = true
	get_tree().create_timer(multisell_delay).timeout.connect(start_multisell)
	


func _on_sell_button_button_up():
	pressed = false
	if multisell:
		
		multisell = false
		sell_button.text = "Sell 1"
		if interact_callback!= null:
			interact_callback.call(item,multisell_amount)
		
	

