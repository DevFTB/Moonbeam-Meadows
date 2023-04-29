extends Resource
class_name FertiliserResource

@export var fertiliser_name := "Fertiliser"
@export var growth_multiplier : float
@export var fertiliser_item : InventoryItem

func _init(p_fertiliser_name := "Fertiliser", p_growth_multiplier := 2.0 , p_fertiliser_item = null):
    fertiliser_name = p_fertiliser_name
    growth_multiplier = p_growth_multiplier
    fertiliser_item = p_fertiliser_item