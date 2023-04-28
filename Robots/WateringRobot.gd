extends "res://Robots/Robot.gd"

@export var max_water_tank = 10
var water_tank = 10

@export var water_threshold = 0.7

func can_do_action(grid_position):
	var should_water = level.get_water_level(grid_position) < water_threshold and level.has_crop(grid_position)
	return water_tank > 0 and should_water

func do_action(grid_position):
	if level.water_land(grid_position):
		water_tank -= 1
		super.do_action(grid_position)
		
func power_down():
	$WheelParticlesLeft.emitting = false
	$WheelParticlesRight.emitting = false
	super.power_down()

func on_move_start():
	$WheelParticlesLeft.emitting = true
	$WheelParticlesRight.emitting = true
	super.on_move_start()
