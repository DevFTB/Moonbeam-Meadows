extends Resource
class_name InventoryItem
## A resource describing an item that can be stored in InventoryComponents

enum ItemType {
	SEED,
	PRODUCE,
	FERTILISER,
	ROBOT,
	ROBOT_UPGRADE,
	WATER
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

func get_buy_price() -> int:
	return buy_price

func get_sell_price()-> int:
	return sell_price

func get_type() -> ItemType:
	return item_type

static func type_to_string(type: ItemType):
	match type:
		ItemType.SEED:
			return "Seed"
		ItemType.PRODUCE:
			return "Produce"
		ItemType.FERTILISER:
			return "Fertiliser"
		ItemType.ROBOT:
			return "Robot"
		ItemType.ROBOT_UPGRADE:
			return "Robot Upgrade"
		ItemType.WATER:
			return "Water"
		_:
			return "Unknown"