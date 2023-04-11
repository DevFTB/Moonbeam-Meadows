extends Resource
class_name CropResource

@export var crop_name = "Crop"

@export_subgroup("Entity")
#CropEntity
@export var amount_of_stages = 3
@export var stage_textures : Array[Texture2D]
@export var rate_of_growth : float = 1
@export var dehydration_rate : float = 0.05

@export_subgroup("Item")
@export var seed_texture : Texture2D
@export var item_texture : Texture2D

