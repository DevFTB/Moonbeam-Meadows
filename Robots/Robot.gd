extends CharacterBody2D
class_name Robot

@export var robot_type : RobotResource
@export var movement_speed: float = 125.0
@export var movement_penalty : float = 0.25
@export var move_energy_cost = 1
@export var action_energy_cost = 3
@export var path : Array[Vector2] = []

var path_index = 0
var movement_delta : float
var powered = true

@onready var energy = robot_type.robot_energy_capacity
@onready var level = get_node("/root/Level") as Level
@onready var navigation_agent = $NavigationAgent2D


func _ready():
	navigation_agent.velocity_computed.connect(_on_NavigationAgent2D_velocity_computed)

func _physics_process(_delta):
	if navigation_agent.is_navigation_finished():
		# decide next destination
		if has_energy():
			if path_index < path.size() - 1:
				path_index += 1
				move_to_grid(path[path_index])
		else:
			power_down()
		return

	movement_delta = movement_speed
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()
	var current_agent_position: Vector2 = global_transform.origin
	var new_velocity: Vector2 = (next_path_position - current_agent_position).normalized() * movement_delta

	navigation_agent.set_velocity(new_velocity)

func has_energy():
	return energy > 0

func power_down():
	powered = false
	pass

func set_path(new_path: Array[Vector2]):
	path = new_path
	move_to_grid(path[1])
	path_index = 1
	pass

func move_to_grid(grid_position: Vector2i):
	navigation_agent.set_target_position(level.map_to_local(grid_position))
	pass

func _on_NavigationAgent2D_velocity_computed(safe_velocity: Vector2):
	# Move CharacterBody3D with the computed `safe_velocity` to avoid dynamic obstacles.
	velocity = safe_velocity
	move_and_slide()
