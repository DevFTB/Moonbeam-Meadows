extends Resource
class_name CropResource

@export var crop_name : String

@export var seed_item : InventoryItem
@export var produce_item : InventoryItem

@export_subgroup("Entity")
@export var amount_of_stages : int
@export var stage_textures : Array[Texture2D]
@export var rate_of_growth : float
@export var dehydration_rate : float

func _init(p_crop_name = "Crop", p_amount_of_stages = 3, p_stage_textures : Array[Texture2D] = [], p_rate_of_growth = 1, p_dehydration_rate = 0.05, p_seed_item = null, p_produce_item = null):
	seed_item = p_seed_item
	produce_item = p_produce_item
	crop_name = p_crop_name
	amount_of_stages = p_amount_of_stages
	stage_textures = p_stage_textures
	rate_of_growth = p_rate_of_growth
	dehydration_rate = p_dehydration_rate
