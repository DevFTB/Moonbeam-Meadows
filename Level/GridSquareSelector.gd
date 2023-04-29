extends Node2D

@onready var level = get_node("/root/Level")
@export var grid_size = 32

@export var valid_colour: Color
@export var invalid_colour: Color 
var valid_cb : Callable

var grid_position = Vector2(0,0)

func _process(delta):
	if visible:
		queue_redraw()

func _draw():
	var mouse_position = get_global_mouse_position()
	grid_position = Vector2(floor(mouse_position.x / grid_size), floor(mouse_position.y / grid_size))
	if valid_cb:
		if valid_cb.call(get_global_mouse_position()):
			draw_rect(Rect2(grid_position * grid_size ,Vector2(32,32)), valid_colour, false, 4.0)
		else:
			draw_rect(Rect2(grid_position * grid_size ,Vector2(32,32)), invalid_colour, false, 4.0)
	else:
		draw_rect(Rect2(grid_position * grid_size ,Vector2(32,32)), valid_colour, false, 4.0)