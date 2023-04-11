extends TileMap

var crop_entity_scene = preload("res://Level/Crops/crop_entity.tscn")

@export var crops : Array[CropResource] = []

var crop_map = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	$Player/InventoryComponent.add_seed(crops[0], 5)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func get_entity_at_grid(grid_position : Vector2i):
	return crop_map.get(grid_position)

func plant_land(grid_position : Vector2i, crop: CropResource):
	# check if land is plantable
	var tile_data = get_cell_tile_data(0, grid_position)
	if tile_data != null and tile_data.get_custom_data("farmland") and get_entity_at_grid(grid_position) == null:
		# create crop entity	
		var crop_entity  = crop_entity_scene.instantiate()
		
		crop_entity.set_crop(crop)
		crop_entity.position = map_to_local(grid_position)
		
		$Entities.add_child(crop_entity)
		
		crop_map[grid_position] = crop_entity
	
	# charge inventory
		return true
	else:
		return false
	pass

func till_land(grid_position : Vector2i):
	var tile_data = get_cell_tile_data(0, grid_position)
	if tile_data != null and tile_data.get_custom_data("tillable"):
		set_cell(0, grid_position, 0, Vector2(0,1))
	pass
	
func water_land(grid_position: Vector2i):
	if crop_map.has(grid_position):
		crop_map[grid_position].fill_water()
		return true
	else:
		return false
