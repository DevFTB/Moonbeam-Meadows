extends InteractableConstruction
class_name EnergyStation

@export var power_range = 2
var robots = []

var power_tiles = []
# Called when the node enters the scene tree for the first time.
func _ready():
	calculate_power_tiles()
	for robot in get_tree().get_nodes_in_group("robot"): add_robot(robot)
	pass # Replace with function body.

func calculate_power_tiles():
	var level = get_node("/root/Level") as Level
	var grid_position = level.local_to_map(position)	
	for i in range(-power_range, power_range + 1):
		for j in range(-power_range, power_range + 1):
			power_tiles.append(grid_position + Vector2i(i, j))

func add_robot(robot: Robot) -> void:
	robots.append(robot)
	robot.parent_energy_station = self
	gui.update_gui()

func set_gui_owner():
	gui.set_energy_station(self)

func is_power_tile(grid_position: Vector2i) -> bool:
	return grid_position in power_tiles

func show_area():
	var level = get_node("/root/Level") as Level 	
	for tile in power_tiles:
		level.highlight_tile(tile)

func hide_area():
	var level = get_node("/root/Level") as Level 	
	level.clear_highlight()
	pass

func remove_robot(robot: Robot) -> void:
	robots.erase(robot)
	gui.update_gui()