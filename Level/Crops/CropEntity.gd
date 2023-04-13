extends Node2D

var fertilised = false

@export var crop : CropResource = null
var current_stage = 0
var growth_prop = 0
var water_level = 1.0

@onready var level = get_node("/root/Level")

# Called when the node enters the scene tree for the first time.
func _ready():
	set_crop(crop)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if crop != null:
		water_level = max(0, water_level - (crop.dehydration_rate * delta))
		$WaterLabel.text = "%.0f" % (water_level * 100)
		
		if growth_prop < 1 and water_level > 0:
			var rate_of_growth = 1.0 / (crop.growth_time * 60)
			var growth_amnt = rate_of_growth * delta * get_temp_mod(level.temp)
			growth_prop = min(1, growth_prop + growth_amnt)
			$GrowthLabel.text = "%.0f" % (growth_prop * 100)
			
		current_stage = floor(growth_prop * (crop.amount_of_stages - 1))
		$CropSprite.texture = crop.stage_textures[current_stage]


func get_temp_mod(temp):
	# abs range determines how steep and far the temp mod absolute function goes
	# if you want the crop to be more heat sensitive, increase this value
	var abs_range = crop.heat_sensitivity
	
	var temp_diff = abs(temp - crop.optimal_temperature)
	var time_mod = crop.max_temp_modifier if temp_diff >= abs_range else (crop.max_temp_modifier - 1.0)/abs_range * temp_diff + 1
	return 1.0/time_mod
	

# Sets the crop entity as fertilised 
func fertilise(_fertiliser : FertiliserResource):
	# Only fertilise if there isn't a crop
	if crop == null:
		fertilised = true
	pass

func set_crop(new_crop: CropResource):
	self.crop = new_crop 
	if crop != null:
		$CropSprite.texture = crop.stage_textures[0]
		current_stage = 0
		
		$WaterLabel.visible = true
		$GrowthLabel.visible = true

#func increment_stage():
#	if current_stage < crop.amount_of_stages - 1:
#		current_stage += 1
#		$CropSprite.texture = crop.stage_textures[current_stage]
#	pass
	
func is_fully_grown():
	return  crop != null and growth_prop == 1

func fill_water():
	water_level = 1
	
func harvest():
	crop = null
	$CropSprite.texture = null
	$WaterLabel.visible = false
	$GrowthLabel.visible = false
