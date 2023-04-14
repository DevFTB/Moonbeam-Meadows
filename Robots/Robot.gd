extends CharacterBody2D

@onready var level = get_node("/root/Level") as Level
@onready var navigation_agent = $NavigationAgent2D

@export var movement_speed: float = 125.0
@export var movement_penalty : float = 0.25
var movement_delta : float

@export var max_energy = 30
@export var move_energy_cost = 1
@export var action_energy_cost = 3

@export var path : Array[Vector2] = []

func _ready():
	navigation_agent.velocity_computed.connect(_on_NavigationAgent2D_velocity_computed)

func _physics_process(delta):
	if navigation_agent.is_navigation_finished():
		return

	movement_delta = movement_speed
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()
	var current_agent_position: Vector2 = global_transform.origin
	var new_velocity: Vector2 = (next_path_position - current_agent_position).normalized() * movement_delta

	navigation_agent.set_velocity(new_velocity)

func move_to_grid(grid_position: Vector2i):
	navigation_agent.set_target_position(level.map_to_local(grid_position))
	pass

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		move_to_grid(level.local_to_map(get_global_mouse_position()))
	pass

func _on_NavigationAgent2D_velocity_computed(safe_velocity: Vector2):
	# Move CharacterBody3D with the computed `safe_velocity` to avoid dynamic obstacles.
	velocity = safe_velocity
	move_and_slide()
