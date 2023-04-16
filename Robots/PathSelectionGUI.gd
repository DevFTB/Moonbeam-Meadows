extends Control

@onready var level = get_node("/root/Level") as Level
@onready var grid_path_line = get_node("/root/Level/GridPathLine")
@onready var player = get_node("/root/Level/Player")
var dragging = false
@export var minimum_motion = 8
var last_mouse_pos : Vector2 = Vector2.ZERO

var grid_positions: Array[Vector2] = []
@export var colour : Color
@export var line_width = 5.0
# Called when the node enters the scene tree for the first time.
func _ready():
	player.frozen = visible
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func check_pos(mouse_position: Vector2):
	var new_point = Vector2(level.local_to_map(mouse_position))
	var is_not_same = grid_positions.size() == 0 or grid_positions.back() != new_point
	var is_traversible = level.get_cell_tile_data(0, new_point).get_custom_data("r_traversible")
	var is_continuous = grid_positions.size() == 0 or (grid_positions.back() - new_point).length() == 1
	if is_not_same and is_traversible and is_continuous:
		print(new_point)
		grid_positions.append(new_point)
		
		grid_path_line.set_points(grid_positions.map(func(x): return level.map_to_local(x)))
	pass

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			dragging = event.pressed
		pass
	elif event is InputEventMouseMotion:
		#print("( %s ) vs ( %s ) vs ( %s )" % [player.get_global_mouse_position(), get_global_mouse_position(), get_viewport_transform() * get_global_mouse_position()])
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

func _input(event):
	if event is InputEventKey and event.keycode == KEY_ENTER:
		get_node("/root/Level/Robots/Robot").set_path(grid_positions)
