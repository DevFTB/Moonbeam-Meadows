extends Node2D
class_name Chunk
@export var exclusion_vectors : Array[Vector2]

var water_inventory: WaterInventory:
	get:
		return $WaterInventory

func _ready():
	water_inventory.depeleted.connect(_on_depleted)

func _on_depleted():
	$Sprite2D.play("used")