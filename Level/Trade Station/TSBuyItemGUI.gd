extends Control

## A item tile in the trade station that allows the player to buy items or multibuy items
@export var item : InventoryItem = null
@export var player_inventory : Node 

## The delay before multibuy starts
@export var multibuy_delay = 0.7
 
## The rate at which multibuy increases
@export var multibuy_rate = 10.0

@export var icon_texture_rect : TextureRect
@export var name_label : Label
@export var cost_label : Label
@export var buy_button : Button

var multibuy = false
var multibuy_timer = 0.0
var multibuy_amount = 0
var pressed = false

var max_amount = 1

var trade_station : InteractableConstruction

@onready var currency_manager : Node = get_node("/root/Level/CurrencyManager")

func _ready():
	currency_manager.currency_changed.connect(func(_x): update_gui())
# Called when the node enters the scene tree for the first time.
func _process(delta):
	if multibuy:
		multibuy_timer += delta
		if multibuy_timer > 1.0 / multibuy_rate:
			multibuy_timer = 0.0
			if multibuy_amount < max_amount:
				multibuy_amount += 1
				buy_button.text = "Buy " + str(multibuy_amount)
			pass
	pass

func set_item(new_item:InventoryItem, _amount =1 ): 
	item = new_item
	icon_texture_rect.texture = item.item_icon
	name_label.text = item.item_name
	cost_label.text = str(item.buy_price)

func start_multibuy():
	if pressed:
		multibuy = true
		multibuy_timer = 0
		max_amount = floor(currency_manager.get_currency() / item.buy_price)
	pass

func update_gui():
	buy_button.disabled = currency_manager.get_currency() < item.buy_price	
	pass

func set_trade_station(new_trade_station: Node):
	trade_station = new_trade_station
	update_gui()
	pass

func _on_buy_button_pressed():
	if not multibuy:
		currency_manager.buy(trade_station.get_interacting_player(), item, 1)	
	


func _on_buy_button_button_down():
	pressed = true
	get_tree().create_timer(multibuy_delay).timeout.connect(start_multibuy)
	


func _on_buy_button_button_up():
	pressed = false
	if multibuy:
		currency_manager.buy(trade_station.get_interacting_player(), item, multibuy_amount)	
		multibuy = false
		buy_button.text = "Buy 1"
		
	
