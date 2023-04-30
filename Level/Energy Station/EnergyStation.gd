extends InteractableConstruction
class_name EnergyStation

## A station that powers robots and provides an interface to manage them.

## A robot was added to the station
signal robot_added(robot: Robot)

## A robot was removed from the station
signal robot_removed(robot: Robot)

## The square grid range of the station's power
@export var energy_range = 2

## The robots assigned to the energy station
var robots = []

## The tiles that the station's power affects
var power_tiles = []

@onready var battery = $Battery

func _ready():
	$RobotInteractor.update_range(energy_range)
	_calculate_power_tiles()
	#for robot in get_tree().get_nodes_in_group("robot"): add_robot(robot)
	pass 

## Add a robot to the station
func add_robot(robot: Robot) -> void:
	robots.append(robot)
	robot.parent_energy_station = self
	
	gui.update_gui()

## Remove a robot from the station
func remove_robot(robot: Robot) -> void:
	robots.erase(robot)

	robot_removed.emit(robot)
	gui.update_gui()

## Show the area of effect of the station through the tilemap
func show_area() -> void:
	var level = get_node("/root/Level") as Level 	
	for tile in power_tiles:
		level.highlight_tile(tile)

## Hide the area of effect of the station through the tilemap
func hide_area() -> void:
	var level = get_node("/root/Level") as Level 	
	level.clear_highlight()
	pass

func set_gui_owner() -> void:
	gui.set_energy_station(self)

func is_power_tile(grid_position: Vector2i) -> bool:
	return grid_position in power_tiles

func get_battery() -> Node2D:
	return $Battery

func _calculate_power_tiles() -> void:
	var level = get_node("/root/Level") as Level
	var grid_position = level.local_to_map(position)	
	for i in range(-energy_range, energy_range + 1):
		for j in range(-energy_range, energy_range + 1):
			power_tiles.append(grid_position + Vector2i(i, j))

func _on_pulse_timer_timeout():
	pass 

func _on_robot_interactor_robot_entered(robot):
	var req = robot.get_energy_requirement()
	var withdraw_amount = min(battery.value, req)
	if battery.withdraw(withdraw_amount):
		robot.add_energy(withdraw_amount)

func _on_robot_interactor_robot_exited(_robot):
	pass	
