extends CharacterBody2D
class_name Robot

@export var robot_type : RobotResource
@export var movement_speed: float = 125.0
@export var movement_penalty : float = 0.25
@export var move_energy_cost = 1
@export var action_energy_cost = 3
@export var path : Array[Vector2] = []

var path_index = 0
var powered = true

var last_acted = Vector2i.ZERO

@onready var energy = robot_type.robot_energy_capacity
@onready var level = get_node("/root/Level") as Level

var action_directions = [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]

var target_position = null
var is_navigation_finished = true

var direction = Vector2i.ZERO
var temp_path = []

var astar : AStarGrid2D

func _ready():
	level.traversibility_updated.connect(on_traversability_update)
	astar = AStarGrid2D.new()
	astar.size = level.get_used_rect().size
	astar.cell_size = Vector2(32,32)
	astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar.update()
	
	for cell in level.get_used_cells_by_id(0):
		if not level.get_cell_tile_data(0, cell).get_custom_data("r_traversible"):
			astar.set_point_solid(cell)
	
	pass
	
	
func _physics_process(_delta):
	if is_navigation_finished:
		# decide next destination
		if has_energy():
			if temp_path.size() == 0:
				if path_index < path.size() - 1 and energy >= move_energy_cost:
					path_index += 1
					move_to_grid(path[path_index])
				
				var current_position = get_current_position()
				if path.size() > 0 and last_acted != current_position:
					#do actions
					for action in action_directions:
						var action_position = current_position + action
						if can_do_action(action_position) and energy >= action_energy_cost:
							do_action(action_position)

					last_acted = current_position
					print("--------------------------------------")
			else:
				move_to_grid(temp_path.pop_front())
		else:
			power_down()
	else:
		if target_position != null:
			var movement_delta = movement_speed * _delta * Vector2(direction)
			var disp = (level.map_to_local(target_position)- Vector2(global_position) + movement_delta).length()
			if disp < 5:
				global_position = level.map_to_local(target_position)
				is_navigation_finished = true
			else:
				velocity = movement_speed * direction
				move_and_slide()
		else:
			is_navigation_finished = true
				
func on_traversability_update(grid_position: Vector2i, traversible: bool):
	astar.set_point_solid(grid_position, not traversible)
func has_energy():
	return energy > 0

func power_down():
	powered = false
	pass

func set_path(new_path: Array[Vector2]):
	path = new_path
	move_to_grid(path[1])
	path_index = 1

	energy -= move_energy_cost
	pass
	
func move_to_grid(grid_position: Vector2i):
	var current_position = get_current_position()
	if grid_position != current_position:
		if (current_position - grid_position).length() == 1:
			direction =  grid_position - current_position
			target_position = grid_position
			print("target %s" % str(target_position))
			is_navigation_finished = false
		else:
			position = level.map_to_local(current_position)
			temp_path = astar.get_id_path(current_position, grid_position).slice(1)
		pass
	else:
		is_navigation_finished = true

func can_do_action(grid_position: Vector2i)->bool:
	return false
	
func do_action(grid_position: Vector2i) -> void:
	energy -= action_energy_cost
	pass

func _on_NavigationAgent2D_velocity_computed(safe_velocity: Vector2):
	# Move CharacterBody3D with the computed `safe_velocity` to avoid dynamic obstacles.
	velocity = safe_velocity
	move_and_slide()

func get_current_position() -> Vector2i:
	return level.local_to_map(position)
