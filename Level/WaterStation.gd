extends InteractableConstruction
class_name WaterStation
const water = preload("res://Level/WaterStation/item_water.tres")

@export var chunk_extract_range = 2

var chunks : Array = []

@onready var level = get_node("/root/Level") as Level
@onready var water_inventory = $WaterInventory as WaterInventory
func _ready():
	chunks = get_tree().get_nodes_in_group("chunk").filter(func(node): return level.get_grid_distance(position, node.position) < chunk_extract_range)
	pass
	
func _on_extract_timer_timeout():
	for chunk in chunks:
		print("capacity: ", water_inventory.get_available_capacity(), " chunk amount: ", chunk.water_inventory.water_amount)
		if water_inventory.get_available_capacity() > 0:
			if chunk.water_inventory.remove_water(1):
				water_inventory.add_water(1)
	pass # Replace with function body.

func _on_robot_interactor_robot_entered(robot: Robot):
	var wd_params = robot.get_withdrawal_params()
	if wd_params.has(InventoryItem.ItemType.WATER):
		var request_amount = wd_params[InventoryItem.ItemType.WATER]
		if request_amount > 0:
			var wd_amount = min(request_amount, water_inventory.water_amount)
			if wd_amount > 0:
				var wd = {
					water: wd_amount
				}
				
				if robot.confirm_withdrawal(wd):
					print("withdrew water ", wd_amount)
					water_inventory.remove_water(wd_amount)
		
	pass # Replace with function body.

func _on_robot_interactor_robot_exited(robot: Robot):
	pass # Replace with function body.

func get_time_to_fill() -> float:
	var capacity = water_inventory.get_available_capacity()
	if chunks.size() > 0:
		return capacity / $ExtractTimer.wait_time / chunks.size()
	else:
		return INF

func set_gui_owner():
	gui.set_water_station(self)