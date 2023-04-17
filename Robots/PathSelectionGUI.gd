extends Control

@export var minimum_motion = 8
@export var colour : Color
@export var line_width = 5.0

var dragging = false
var last_mouse_pos : Vector2 = Vector2.ZERO
var grid_positions: Array[Vector2] = []
var current_robot = null

signal finished_editing

@onready var level = get_node("/root/Level") as Level
@onready var grid_path_line = get_node("/root/Level/GridPathLine")
@onready var player = get_node("/root/Level/Player")
@onready var editing_camera = get_node("/root/Level/EditingCamera")

func _ready():
	pass # Replace with function body.


func start_editing(robot: Robot):
	current_robot = robot
	player.frozen = true 
	visible = true
	editing_camera.position = player.global_position
	editing_camera.enable()
	grid_positions = robot.path
	update_path_visual()
	pass

func update_path_visual():
	grid_path_line.set_points(grid_positions.map(func(x): return level.map_to_local(x)))
	pass

func check_pos(mouse_position: Vector2):
	var new_point = Vector2(level.local_to_map(mouse_position))
	var is_not_same = grid_positions.size() == 0 or grid_positions.back() != new_point
	var is_traversible = level.get_cell_tile_data(0, new_point).get_custom_data("r_traversible")
	var is_continuous = grid_positions.size() == 0 or (grid_positions.back() - new_point).length() == 1
	if is_not_same and is_traversible and is_continuous:
		print(new_point)
		grid_positions.append(new_point)
		
		update_path_visual()
	pass

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			dragging = event.pressed
		pass
	elif event is InputEventMouseMotion:
		var mouse_pos = player.get_global_mouse_position()
		if dragging:
			if event.relative.length() > minimum_motion:
				check_pos(mouse_pos)
				pass
			else:
				if (mouse_pos - last_mouse_pos).length() > 8:
					last_mouse_pos = mouse_pos
					check_pos(mouse_pos)
		pass
	
	
	pass

func is_path_valid():
	return true

func _on_save_button_pressed():
	if is_path_valid():
		current_robot.set_path(grid_positions)
		editing_camera.disable()
		finished_editing.emit()
		player.frozen = false
		self.visible = false

	pass # Replace with function body.
