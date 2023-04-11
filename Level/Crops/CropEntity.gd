extends Node2D

@export var crop : CropResource = null

var current_stage = 0

var water_level = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	set_crop(crop)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if water_level > 0:
		water_level -= crop.dehydration_rate * delta
		if water_level < 0:
			water_level = 0
	$WaterLabel.text = "%.0f" % (water_level * 100)
	pass

func set_crop(crop: CropResource):
	self.crop = crop
	if crop != null:
		$Sprite2D.texture = crop.stage_textures[0]
		current_stage = 0

func increment_stage():
	if current_stage < crop.amount_of_stages - 1:
		current_stage += 1
		$Sprite2D.texture = crop.stage_textures[current_stage]
	pass


func _on_growth_timer_timeout():
	increment_stage()
	pass # Replace with function body.
