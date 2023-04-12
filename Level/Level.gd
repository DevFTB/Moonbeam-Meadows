extends TileMap
class_name Level

var crop_entity_scene = preload("res://Level/Crops/crop_entity.tscn")

@export var crops : Array[CropResource] = []
@export var fertilisers : Array[FertiliserResource] = []
var crop_map = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	$Player/SeedInventory.add(crops[0], 5)
	$Player/FertiliserInventory.add(fertilisers[0], 5)
	pass # Replace with function body.

func get_entity_at_grid(grid_position : Vector2i):
	return crop_map.get(grid_position)

func plant_land(grid_position : Vector2i, crop: CropResource):
	if crop_map.has(grid_position):
		var crop_entity = crop_map[grid_position]
		if crop_entity.crop == null:
			crop_map[grid_position].set_crop(crop)
			return true

	return false
	
func fertilise_land(grid_position : Vector2i, fertiliser : FertiliserResource):
	if crop_map.has(grid_position):
		crop_map[grid_position].fertilise(fertiliser)
		set_cell(0, grid_position, 0, Vector2i(0, 1))
		return true
	else:
		return false

func till_land(grid_position : Vector2i):
	var tile_data : TileData = get_cell_tile_data(0, grid_position)
	if tile_data != null and tile_data.get_custom_data("tillable"):
		var crop_entity  = crop_entity_scene.instantiate()
		
		crop_entity.position = map_to_local(grid_position)
		
		$Entities.add_child(crop_entity)
		
		crop_map[grid_position] = crop_entity
		set_cell(0, grid_position, 0, Vector2i(0, 0))
	pass
	
func water_land(grid_position: Vector2i):
	if crop_map.has(grid_position):
		crop_map[grid_position].fill_water()
		return true
	else:
		return false
		
func harvest_land(grid_position: Vector2i, inventory):
	if crop_map.has(grid_position):
		var crop_entity = crop_map[grid_position]
		
		if crop_entity.is_fully_grown():
			inventory.add(crop_entity.crop, 1)
			crop_entity.harvest()
	pass
