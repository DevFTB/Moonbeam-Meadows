extends Node2D

var fertilised = false

@export var crop : CropResource = null
var current_stage = 0
var water_level = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	set_crop(crop)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if crop != null:
		if water_level > 0:
			water_level -= crop.dehydration_rate * delta
			if water_level < 0:
				water_level = 0
		$WaterLabel.text = "%.0f" % (water_level * 100)
	pass

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
		
		$GrowthTimer.start()
		$WaterLabel.visible = true

func increment_stage():
	if current_stage < crop.amount_of_stages - 1:
		current_stage += 1
		$CropSprite.texture = crop.stage_textures[current_stage]
	pass
	
func is_fully_grown():
	return  crop != null and current_stage == crop.amount_of_stages - 1

func fill_water():
	water_level = 1
	
func harvest():
	crop = null
	$CropSprite.texture = null
	$GrowthTimer.stop()
	$WaterLabel.visible = false

func _on_growth_timer_timeout():
	increment_stage()
	pass # Replace with function body.
