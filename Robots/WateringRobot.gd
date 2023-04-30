extends "res://Robots/Robot.gd"

const water = preload("res://Level/WaterStation/item_water.tres")

@export var water_threshold = 0.7
@onready var water_inventory = $WaterInventory as WaterInventory

@export var water_duration = 0.2
var water_timer = 0
var is_watering = false

func _on_ready():
	_process

func can_do_action(grid_position):
	var should_water = level.get_water_level(grid_position) < water_threshold and level.has_crop(grid_position)
	return water_inventory.water_amount > 0 and should_water

func do_action(grid_position):
	if level.water_land(grid_position):
		if water_inventory.remove(water, 1):
			super.do_action(grid_position)
			
func power_down():
	$WheelParticlesLeft.emitting = false
	$WheelParticlesRight.emitting = false
	super.power_down()

func _on_move_start():
	$WheelParticlesLeft.emitting = true
	$WheelParticlesRight.emitting = true
	super._on_move_start()

func get_specific_description():
	return "Water tank: " + str(water_inventory.water_amount) + "/" + str(water_inventory.inventory_size)
	
func _process(delta):
	if target_position != null and acted_last_tile == true :
		is_watering = true
	if is_watering == true:
		$WaterParticles.emitting = true
		water_timer += delta
	while water_timer >= water_duration:
		water_timer = 0
		$WaterParticles.emitting = false
		is_watering = false
		
