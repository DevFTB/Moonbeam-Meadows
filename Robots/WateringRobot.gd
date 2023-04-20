extends "res://Robots/Robot.gd"

@export var max_water_tank = 10
var water_tank = 10

@export var water_threshold = 0.7

func can_do_action(grid_position):
	var should_water = level.get_water_level(grid_position) < water_threshold
	print("water level at %s is %f" % [str(grid_position), level.get_water_level(grid_position)])
	return water_tank > 0 and should_water

func do_action(grid_position):
	if level.water_land(grid_position):
		print("watered land at %s" % str(grid_position))
		print("water level now %d" % water_tank )
		water_tank -= 1
		super.do_action(grid_position)
