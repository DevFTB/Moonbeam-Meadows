extends TileMap
class_name Level

var crop_entity_scene = preload("res://Level/Crops/crop_entity.tscn")

@export var crops : Array[CropResource] = []
@export var fertilisers : Array[FertiliserResource] = []
@export var robots : Array[RobotResource] = []
@export var robot_upgrades : Array[RobotUpgrade] = []
var crop_map = {}

@export var base_temp = 20

signal traversibility_updated(grid_pos: Vector2i, traversible: bool)

# Called when the node enters the scene tree for the first time.
func _ready():
	$Player/SeedInventory.add(crops[0].seed_item, 5)
	$Player/ProduceInventory.add(crops[0].produce_item,50)
	$Player/FertiliserInventory.add(fertilisers[0].fertiliser_item, 5)
	pass # Replace with function body.

func get_entity_at_grid(grid_position : Vector2i):
	return crop_map.get(grid_position)

func plant_land(grid_position : Vector2i, item: InventoryItem) -> bool:
	var crop = lookup_crop(item)
	if crop_map.has(grid_position):
		var crop_entity = crop_map[grid_position]
		if crop_entity.crop == null:
			crop_map[grid_position].set_crop(crop)
			return true

	return false
	
func fertilise_land(grid_position : Vector2i, item: InventoryItem) -> bool:
	var fertiliser = lookup_fertiliser(item)
	if crop_map.has(grid_position):
		crop_map[grid_position].fertilise(fertiliser)
		set_cell(0, grid_position, 0, Vector2i(0, 1))
		return true
	else:
		return false

func till_land(grid_position : Vector2i) -> bool:
	var tile_data : TileData = get_cell_tile_data(0, grid_position)
	if tile_data != null and tile_data.get_custom_data("tillable"):
		var crop_entity  = crop_entity_scene.instantiate()
		
		crop_entity.position = map_to_local(grid_position)
		crop_entity.grid_position = grid_position
		
		$Entities.add_child(crop_entity)
		
		crop_map[grid_position] = crop_entity
		set_cell(0, grid_position, 0, Vector2i(0, 0))
		traversibility_updated.emit(grid_position, false)
		
		#play till audio
		return true
	else:
		return false
func is_traversible(grid_position: Vector2i):
	var tile_data : TileData = get_cell_tile_data(0, grid_position)
	return tile_data != null and tile_data.get_custom_data("r_traversible")
func get_temp(grid_position : Vector2i):
	return base_temp

func get_water_level(grid_position : Vector2i):
	if crop_map.has(grid_position):
		return crop_map[grid_position].get_water_level()
	else:
		return 0
func water_land(grid_position: Vector2i):
	if crop_map.has(grid_position):
		crop_map[grid_position].fill_water()
		return true
	else:
		return false

const ItemType = preload("res://Inventory/InventoryItem.gd").ItemType	
func harvest_land(grid_position: Vector2i, entity: Node2D):
	if crop_map.has(grid_position):
		var crop_entity = crop_map[grid_position]
		
		if crop_entity.is_fully_grown():
			entity.get_inventory(ItemType.PRODUCE).add(crop_entity.crop.produce_item, 1)
			crop_entity.harvest()
	pass

func place_robot_near_station(robot: RobotResource, energy_station: EnergyStation) -> bool:
	var tgt_grid_pos = local_to_map(energy_station.global_position)
	
	for i in range(-1, 2):
		for j in range(-1, 2):
			var grid_pos = Vector2i(tgt_grid_pos.x + i, tgt_grid_pos.y + j)
			if is_traversible(grid_pos) and not crop_map.has(grid_pos) and grid_pos != tgt_grid_pos and $Robots.get_children().all(func(r): return r.get_current_position() != grid_pos):
				if $Player.get_inventory(InventoryItem.ItemType.ROBOT).remove(robot.robot_item, 1):
					var robot_entity = robot.generate_entity()

					robot_entity.position = map_to_local(grid_pos)

					$Robots.add_child(robot_entity)
					energy_station.add_robot(robot_entity)
					return true
	
	return false

func lookup_crop(item: InventoryItem):
	for crop in crops:
		if crop.seed_item == item or crop.produce_item == item:
			return crop
	return null

func lookup_fertiliser(item: InventoryItem):
	for fertiliser in fertilisers:
		if fertiliser.fertiliser_item == item:
			return fertiliser
	return null

func lookup_robot(item: InventoryItem):
	return robots.filter(func(r): return r.robot_item == item).front()
	
func lookup_robot_upgrade(item: InventoryItem):
	return robot_upgrades.filter(func(r): return r.upgrade_item == item).front()

var highlight = preload("res://Level/hightlight.png")
func highlight_tile(grid_position : Vector2i):
	set_cell(1, grid_position, 1, Vector2i(0, 0))

	pass

func clear_highlight():
	for cell in get_used_cells_by_id(1):
		set_cell(1, cell, -1)

func get_crop_entity(grid_position: Vector2i) -> CropEntity:
	return crop_map.get(grid_position)

func has_crop(grid_position: Vector2i) -> bool:
	return crop_map.has(grid_position)
