extends "res://Robots/Robot.gd"

func can_do_action(grid_position):
	var crop_entity = level.get_crop_entity(grid_position) as CropEntity
	return crop_entity != null and not crop_entity.has_crop() and not crop_entity.fertilised

func do_action(grid_position):
	var selected = $FertiliserInventory.get_selected()
	if level.fertilise_land(grid_position, selected):
		$FertiliserInventory.remove(selected, 1)
		super.do_action(grid_position)

func power_down():
	$WheelParticlesLeft.emitting = false
	$WheelParticlesRight.emitting = false
	super.power_down()

func _on_move_start():
	$WheelParticlesLeft.emitting = true
	$WheelParticlesRight.emitting = true
	super._on_move_start()

