extends Resource
class_name CropResource

@export var crop_name : String

@export var seed_item : InventoryItem
@export var produce_item : InventoryItem

@export_subgroup("Entity")
@export var amount_of_stages : int
@export var stage_textures : Array[Texture2D]
# growth time in real time minutes
@export var growth_time : float
@export var dehydration_rate : float
@export var optimal_temperature: float
@export var max_temp_modifier: float
@export var heat_sensitivity: float

func _init(p_crop_name = "Crop", p_amount_of_stages = 3, p_stage_textures : Array[Texture2D] = [], p_growth_time = 2, p_dehydration_rate = 0.05, p_optimal_temperature = 20, p_max_temp_modifier = 2, p_heat_sensitivity = 15, p_seed_item = null, p_produce_item = null):
	seed_item = p_seed_item
	produce_item = p_produce_item
	crop_name = p_crop_name
	amount_of_stages = p_amount_of_stages
	stage_textures = p_stage_textures
	growth_time = p_growth_time
	dehydration_rate = p_dehydration_rate
	optimal_temperature = p_optimal_temperature
	max_temp_modifier = p_max_temp_modifier
	heat_sensitivity = p_heat_sensitivity
	
