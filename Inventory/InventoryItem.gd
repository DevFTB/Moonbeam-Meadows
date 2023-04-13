extends Resource
class_name InventoryItem

enum ItemType {
	SEED,
	PRODUCE,
	FERTILISER,
	ROBOT
}

@export var item_name : String 
@export var item_icon : Texture2D
@export var item_type : ItemType 

@export var buy_price : int
@export var sell_price: int

func _init(p_item_name = "New Item", p_item_icon = null, p_item_type = ItemType.SEED, p_buy_price = 0, p_sell_price = 0):
	item_name = p_item_name
	item_icon = p_item_icon
	item_type = p_item_type
	buy_price = p_buy_price
	sell_price = p_sell_price

func get_buy_price():
	return buy_price

func get_sell_price():
	return sell_price

func get_type():
	return item_type