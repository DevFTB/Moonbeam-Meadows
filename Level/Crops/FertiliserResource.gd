extends Resource
class_name FertiliserResource

@export var fertiliser_name = "Fertiliser"
@export var growth_multiplier = 2
@export var item_texture : Texture2D

func get_display_name():
	return fertiliser_name
