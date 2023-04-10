extends TileMap


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func till_land(grid_position : Vector2i):
	var tile_data = get_cell_tile_data(0, grid_position)
	if tile_data != null and tile_data.get_custom_data("tillable"):
		set_cell(0, grid_position, 0, Vector2(0,1))
	pass
