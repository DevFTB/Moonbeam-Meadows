extends "res://Robots/Robot.gd"

func can_do_action(grid_position):
	var crop_entity = level.get_crop_entity(grid_position)
	return crop_entity != null and not crop_entity.has_crop()

func do_action(grid_position):
	var selected = $SeedInventory.get_selected()
	if level.plant_land(grid_position, selected):
		$SeedInventory.remove(selected, 1)
		super.do_action(grid_position)

func get_inventory(item_type: InventoryItem.ItemType) -> InventoryComponent:
	if item_type == InventoryItem.ItemType.SEED:
		return $SeedInventory
	return null

func power_down():
	$WheelParticlesLeft.emitting = false
	$WheelParticlesRight.emitting = false
	super.power_down()

func _on_move_start():
	$WheelParticlesLeft.emitting = true
	$WheelParticlesRight.emitting = true
	super._on_move_start()

