extends Node2D
class_name Chunk
@export var exclusion_vectors : Array[Vector2]

var water_inventory: WaterInventory:
	get:
		return $WaterInventory

func init_level(level: Level):
	for vec in exclusion_vectors:
		level.set_grid_intraversible(vec)
	pass
