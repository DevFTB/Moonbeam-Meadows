extends CharacterBody2D
class_name Player

@export var speed = 125  # speed in pixels/sec

signal tool_changed(new_tool: Tool)
signal freeze_changed(frozen: bool)

enum Tool {
	TILL, WATER, PLANT, FERTILISE, HARVEST, 
}

var current_tool = Tool.TILL

var facing = Vector2.DOWN

var frozen = false

@onready var inventories = get_children().filter(func(child):
	return child is InventoryComponent
)

@export var max_water_tank = 10
@onready var water_tank = max_water_tank

func _physics_process(delta):
	if not frozen:
		var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		facing = direction.normalized()
		velocity = direction * speed

		move_and_slide()

func switch_tool(tool : Tool):
	if current_tool != tool:
		current_tool = tool
		# play tool switching sound
		# update tool GUI
		tool_changed.emit(current_tool)
		
	pass
	
func use_tool(grid_position):
	if not frozen:
		match(current_tool):
			Tool.TILL:
				get_parent().till_land(grid_position)
			Tool.PLANT:
				if $SeedInventory.get_selected() != null:
					if get_parent().plant_land(grid_position, $SeedInventory.get_selected()):
						$SeedInventory.remove($SeedInventory.get_selected())
			Tool.FERTILISE:
				if $FertiliserInventory.get_selected() != null:
					if get_parent().fertilise_land(grid_position, $FertiliserInventory.get_selected()):
						$FertiliserInventory.remove($FertiliserInventory.get_selected())
			Tool.WATER:
				if water_tank > 0:
					if get_parent().water_land(grid_position):
						water_tank -= 1
			Tool.HARVEST:
				get_parent().harvest_land(grid_position, self)
	pass

func fill_water_tank():
	water_tank = max_water_tank

const ItemType = preload("res://Inventory/InventoryItem.gd").ItemType
func get_inventory(item_type: ItemType) -> InventoryComponent:
	var type_inventories = inventories.filter(func(child):
		return child.inventory_type == item_type
	)
	return type_inventories[0] if type_inventories.size() > 0 else null
func _input(event):

	if event is InputEventKey and not frozen:
		if event.is_action_pressed("select_tool1"):
			switch_tool(Tool.TILL)
			pass
		elif event.is_action_pressed("select_tool2"):
			switch_tool(Tool.PLANT)
			pass
		elif event.is_action_pressed("select_tool3"):
			switch_tool(Tool.WATER)
			pass
		elif event.is_action_pressed("select_tool4"):
			switch_tool(Tool.FERTILISE)
			pass
		elif event.is_action_pressed("select_tool5"):
			switch_tool(Tool.HARVEST)
			pass

func freeze():
	frozen = true
	freeze_changed.emit(frozen)	
	pass

func unfreeze():
	frozen = false
	freeze_changed.emit(frozen)
	pass
