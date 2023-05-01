extends Node2D

## This is a helper node that draws a grid on the screen

## The size of the grid
@export var grid_size = 32

## The colour of the square when it is valid
@export var valid_colour: Color

## The colour of the square when it is invalidj
@export var invalid_colour: Color 

## The callback to check if the square is valid
var valid_cb : Callable

## The position of the square
var grid_position = Vector2(0,0)

@onready var level = get_node("/root/Level")

func _process(_delta):
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