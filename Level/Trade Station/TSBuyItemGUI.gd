extends Control

@export var crop : CropResource = null
@export var player_inventory : Node 
@export var multibuy_delay = 0.7
@export var multibuy_rate = 10.0

@onready var currency_manager : Node = get_node("/root/Level/CurrencyManager")

var multibuy = false
var multibuy_timer = 0.0
var multibuy_amount = 0
var pressed = false

var max_amount = 1

var trade_station : Node = null

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
				$VBoxContainer/BuyButton.text = "Buy " + str(multibuy_amount)
			pass
	pass

func set_crop(crop: CropResource):
	self.crop = crop
	$IconTextureRect.texture = crop.seed_texture
	$NameLabel.text = crop.crop_name
	$VBoxContainer/HBoxContainer/CostLabel.text = str(crop.seed_cost)

func start_multibuy():
	print("start multibuy")

	if pressed:
		multibuy = true
		multibuy_timer = 0
		max_amount = floor(currency_manager.get_currency() / crop.seed_cost)
	pass

func _on_buy_button_pressed():
	if not multibuy:
		currency_manager.buy(trade_station.get_interacting_player(), crop, 1)	
	pass # Replace with function body.


func _on_buy_button_button_down():
	pressed = true
	get_tree().create_timer(multibuy_delay).timeout.connect(start_multibuy)
	pass # Replace with function body.


func _on_buy_button_button_up():
	pressed = false
	if multibuy:
		print("multibuy %d" % multibuy_amount)
		currency_manager.buy(trade_station.get_interacting_player(), crop, multibuy_amount)	
		multibuy = false
		$VBoxContainer/BuyButton.text = "Buy 1"
		
	pass # Replace with function body.

func update_gui():
	$VBoxContainer/BuyButton.disabled = currency_manager.get_currency() < crop.seed_cost	
	pass

func set_trade_station(new_trade_station: Node):
	trade_station = new_trade_station
	update_gui()
	pass
