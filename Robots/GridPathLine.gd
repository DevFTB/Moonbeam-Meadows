extends Node2D

@export var points : PackedVector2Array

@export var line_colour : Color
@export var line_width = 5.0

@export var tile_colour : Color
@export var tile_line_width = 5.0
@export var final_tile_colour : Color

func set_points(new_points):
	self.points = PackedVector2Array(new_points)
	queue_redraw()

func _draw():
	if points.size() > 1:
		for i in range(points.size() - 1):
			var p1 = points[i]
			var p2 = points[i+1]
			
			var vec = p2 - p1
			var perpendicular_vec = vec.normalized().orthogonal()
			
			var p1_1 = p1 + perpendicular_vec * line_width / 2
			var p1_2 = p1 - perpendicular_vec * line_width / 2
			var p2_1 = p2 + perpendicular_vec * line_width / 2
			var p2_2 = p2 - perpendicular_vec * line_width / 2
			
			draw_colored_polygon(PackedVector2Array([p1_1, p1_2, p2_2, p2_1]), line_colour)
			
			draw_rect(Rect2(p1 - Vector2(16,16), Vector2(32,32)), tile_colour, false, tile_line_width)
		
		draw_rect(Rect2(points[points.size() - 1] - Vector2(16,16), Vector2(32,32)), final_tile_colour, false, tile_line_width)
	pass
