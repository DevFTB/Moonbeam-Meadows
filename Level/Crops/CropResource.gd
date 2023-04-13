extends Resource
class_name CropResource

@export var crop_name : String

@export_subgroup("Entity")
#CropEntity
@export var amount_of_stages : int
@export var stage_textures : Array[Texture2D]
@export var rate_of_growth : float
@export var dehydration_rate : float

@export_subgroup("Item")
@export var seed_texture : Texture2D
@export var seed_cost : int

@export var produce_texture : Texture2D
@export var produce_cost : int
func _init(p_crop_name = "Crop", p_amount_of_stages = 3, p_stage_textures : Array[Texture2D] = [], p_rate_of_growth = 1, p_dehydration_rate = 0.05, p_seed_texture = null, p_produce_texture = null, p_seed_cost = 1, p_produce_cost = 1):
	crop_name = p_crop_name
	amount_of_stages = p_amount_of_stages
	stage_textures = p_stage_textures
	rate_of_growth = p_rate_of_growth
	dehydration_rate = p_dehydration_rate
	seed_texture = p_seed_texture
	seed_cost = p_seed_cost
	produce_texture = p_produce_texture
	produce_cost = p_produce_cost

func get_display_name():
	return crop_name
