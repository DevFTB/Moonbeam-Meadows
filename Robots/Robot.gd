extends CharacterBody2D
class_name Robot
 
## A robot entity in the world

class UpgradeInstance:
	extends RefCounted
	## An instance of an upgrade applied to a robot

	## An unique id for this instance
	var inst_id = 0

	## The upgrade this instance is based on
	var upgrade : RobotUpgrade

	## The property name mapping to the amount of modification
	var property_ids = {}

	func _init(p_upgrade: RobotUpgrade, p_inst_id = 0):
		upgrade = p_upgrade
		inst_id = p_inst_id

## The path the robot will follow
@export var path : Array[Vector2i] = []

## The item the robot will give the player once it gets picked up
@export var pickup_item : InventoryItem

## Should the robot deposit the item from its inventory to other inventorie
@export var should_deposit = false

## Should the robot withdraw the item from other inventories
@export var should_withdraw = false

@export var base_movement_speed : float = 125

@export var base_movement_action_penalty : float = 0.25

@export var base_inventory_capacity : int = 10 

@export var base_move_energy_cost  : int = 1

@export var base_action_energy_cost : int = 3

@export var base_energy_capacity : int = 60

@export var starting_upgrades = []

# The distance at which the robot will snap to the target tile
@export var snap_distance = 4

# The percentage of energy capacity the robot will fill too before self powering on.
@export var self_power_energy_threshold = 0.5

# The scaling factor for the snapping distance based on the movement speed as a percentage of the base movement speed
@export var snap_scaling_unit = 0.8

var parent_energy_station = null
var upgrade_counter = 0


var astar : AStarGrid2D
## The upgrades applied to the robot
var upgrades = {}

## Is the robot powered on
var powered = true

## The current energy of the robot
var energy = 0

## The position along the path the robot is currently at
var path_index = 0

## The target position the robot is moving to
var target_position = null

var is_navigation_finished = true
var direction = Vector2i.ZERO

## A temp_path used for the robot overring it's off path detection and energy requirements
var temp_path = []
var temp_path_completed = false

## The directions in with the robot can affect with it's actions
var action_directions = [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]

## The grid the robot last performed an action on
var last_acted = Vector2i.ZERO
## Whether the robot has performed an action on the previous tile
var acted_last_tile = false

## Enables emergency pathing back to the target position
var e_mode= false

## GUI override for the power state. If true the robot will not turn itself on.
var unpowered_override = false

@onready var level = get_node("/root/Level") as Level
@onready var inventories = get_children().filter(func(x): return x is InventoryComponent)

## The speed at which the robot moves 
@onready var movement_speed = TrackedModifierValue.new(base_movement_speed)
## The penalty to movement speed when doing an action
@onready var movement_action_penalty = TrackedModifierValue.new(base_movement_action_penalty)
## The capacity of the robot's inventory
@onready var inventory_capacity = TrackedModifierValue.new(base_inventory_capacity)
## The energy cost of moving to an adjacent grid
@onready var move_energy_cost = TrackedModifierValue.new(base_move_energy_cost)
## The energy cost of doing an action
@onready var action_energy_cost = TrackedModifierValue.new(base_action_energy_cost)
## The energy capacity of the robot
@onready var energy_capacity = TrackedModifierValue.new(base_energy_capacity)

func _ready():
	$ProximityInteractor.successful_pickup.connect(_on_successful_pickup)
	level.traversibility_updated.connect(_on_traversability_update)

	astar = AStarGrid2D.new()
	astar.size = level.get_used_rect().size
	astar.cell_size = Vector2(32,32)
	astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar.update()
	
	for cell in level.get_used_cells_by_id(0):
		if not level.get_cell_tile_data(0, cell).get_custom_data("r_traversible"):
			astar.set_point_solid(cell)
	
	for upgrade in starting_upgrades:
		add_upgrade(upgrade)


	energy = energy_capacity.get_value()
	pass	
	
func _physics_process(_delta):
	if powered:
		if is_navigation_finished and powered:
			acted_last_tile = false
			# check if should power down
			if not has_energy() or path.size() <= 1:
				power_down()
				return

			# travelling temp path overrides normal path
			if temp_path.is_empty():
				temp_path_completed  = true
				# start moving to next grid in path if possible
				if energy >= move_energy_cost.get_value():
					path_index = (path_index + 1) % path.size()
					if level.is_traversible(path[path_index]):
						move_to_grid(path[path_index])
					else:
						power_down()
				

				# try do action in all action directions
				var current_position = get_current_position()
				if last_acted != current_position:
					#do actions
					for action in action_directions:
						var action_position = current_position + action
						if can_do_action(action_position) and energy >= action_energy_cost.get_value():
							do_action(action_position)
							acted_last_tile = true	
							

					last_acted = current_position
					
			else:
				# temp path doesn't cost energy.
				move_to_grid(temp_path.pop_front())

		#	 movement code
		if target_position != null :
			var actual_movement_speed = movement_speed.get_value() if not acted_last_tile else movement_speed.get_value() * movement_action_penalty.get_value()
			var disp = (level.map_to_local(target_position)- Vector2(global_position) ).length()
			if disp < snap_distance * (actual_movement_speed / movement_speed.base_value) / snap_scaling_unit:
				global_position = level.map_to_local(target_position)
				is_navigation_finished = true
			else:
				velocity = actual_movement_speed * direction
				if not is_on_path() or e_mode:
					if e_mode != true: e_mode = true
					velocity = actual_movement_speed * (level.map_to_local(target_position)- Vector2(global_position)).normalized()
					#power_down()
				move_and_slide()
		else:
			is_navigation_finished = true
	
func do_action(_grid_position: Vector2i) -> void:
	energy -= action_energy_cost.get_value()
	pass


func power_down():
	powered = false
	$RobotAnimationController.power_down()
	print(name, " power off")
	pass

func power_on():
	powered= true
	$RobotAnimationController.power_on()
	print(name + "power on")

func check_power():
	if has_energy() and not path.is_empty():
		if can_power_on():
			power_on()
	else:
		if powered:
			power_down()

func can_power_on():
	var on_path = target_position == null or is_on_path()
	return not powered and energy > floor(energy_capacity.get_value() * self_power_energy_threshold) and on_path and not unpowered_override

func set_path(new_path: Array[Vector2i]):
	path = new_path
	check_power()
	if powered:
		move_to_grid(path[0])

	path_index = 0
	pass
	
func add_energy(amount: int) -> void:
	energy = min(energy + amount, energy_capacity.get_value())
	
	check_power()
	pass

func toggle_power():
	if powered:
		unpowered_override = true
		power_down()
	else:
		unpowered_override = false
		if can_power_on():
			power_on()
	pass

func snap_to_grid():
	position = level.map_to_local(get_current_position())

## Starts the robot moving to the given grid position	
func move_to_grid(grid_position: Vector2i):
	_on_move_start()
	snap_to_grid()
	var current_position = get_current_position()

	if grid_position != current_position:
		if (current_position - grid_position).length() == 1:
			direction =  grid_position - current_position
			target_position = grid_position
			energy -= move_energy_cost.get_value()
			
			is_navigation_finished = false
		else:
			position = level.map_to_local(current_position)
			temp_path = astar.get_id_path(current_position, grid_position).slice(1)
			temp_path_completed =false
		pass
	else:
		is_navigation_finished = true

## Given constraints by the requesting entity, the robot generates a deposit of items from its inventory 
func generate_deposit(item_types: Array[InventoryItem.ItemType], max_unique_items: int, max_total_items: int) -> Dictionary:
	var deposit = {}
	var unique_items = 0
	var total_items = 0
	if not inventories.is_empty():
		for item_type in item_types:
			var invs = inventories.filter(func(x): return x.inventory_type == item_type)
			if not invs.is_empty():
				var inv = invs.front()
				if inv != null:
					for item in inv.inventory:
						
						var amnt =  min(inv.inventory[item], max_total_items-total_items)
						if deposit.has(item):
							deposit[item] += amnt
						else:
							deposit[item] = amnt
							unique_items += 1
						total_items += amnt
						if unique_items >= max_unique_items or total_items >= max_total_items:
							return deposit

	return deposit

func confirm_deposit(deposit: Dictionary) -> void:
	# remove items from inventories according to the deposit
	for item in deposit:
		var inv = inventories.filter(func(x): return x.inventory_type == item.item_type).front()
		var amount = min(inv.get_amount(item), deposit[item])
		inv.remove(item, amount)
		deposit[item] -= amount
		if deposit[item] <= 0:
			break

func get_withdrawal_params() -> Dictionary:
	var params = {}
	for inv in inventories:
		params[inv.inventory_type] = inv.get_available_capacity()
	return params

func confirm_withdrawal(withdrawal: Dictionary) -> bool:
	# add items to inventories according to the withdrawal
	for item in withdrawal:
		var invs = inventories.filter(func(x): return x.inventory_type == item.item_type)
		if not invs.is_empty():
			var inv = invs.front()
			if inv == null or inv.get_available_capacity() < withdrawal[item]:
				return false

	for item in withdrawal:
		var invs = inventories.filter(func(x): return x.inventory_type == item.item_type)
		if not invs.is_empty():
			var inv = invs.front()
			if not inv.add(item, withdrawal[item]):
				return false
	
	return true


func remove_self():
	if parent_energy_station != null:
		parent_energy_station.remove_robot(self)
	
	queue_free()

func add_upgrade(upgrade: RobotUpgrade) -> int:
	var inst = UpgradeInstance.new(upgrade, upgrade_counter)
	upgrades[upgrade_counter] = inst
	upgrade_counter += 1

	for property_name in upgrade.upgrade_properties:
		var property = get(property_name)
		if property != null:
			var id = property.add_modifier(upgrade.upgrade_properties[property_name])
			inst.property_ids[property_name] = id 
		break
	return -1

func remove_upgrade(inst_id: int):
	var inst = upgrades[inst_id]
	if inst != null:
		for property_name in inst.upgrade.upgrade_properties:
			var property = get(property_name)
			if property != null:
				property.remove_modifier(inst.property_ids[property_name])
		upgrades.erase(inst_id)
		return true
	return false

func is_on_path():
	return (target_position - get_current_position()).length() <= 1 or not temp_path.is_empty()

func get_inventory(item_type: InventoryItem.ItemType) -> InventoryComponent:
	var invs = inventories.filter(func(x): return x.inventory_type == item_type)
	if not invs.is_empty():
		return invs.front()
	else:
		return null

func get_current_position() -> Vector2i:
	return level.local_to_map(position)
func get_specific_description():
	return ""

func can_do_action(_grid_position: Vector2i)->bool:
	return false

func has_energy(): 
	return energy > 0

func get_energy_requirement():
	return energy_capacity.get_value() - energy 

func _on_move_start():
	pass
	
func _on_successful_pickup(interacting_player: Player):
	interacting_player.get_inventory(InventoryItem.ItemType.ROBOT).add(pickup_item, 1)
	for id in upgrades.keys():
		interacting_player.get_inventory(InventoryItem.ItemType.ROBOT_UPGRADE).add(upgrades[id].upgrade.upgrade_item, 1)
		remove_upgrade(id)
	remove_self()

func _on_traversability_update(grid_position: Vector2i, traversible: bool):
	astar.set_point_solid(grid_position, not traversible)
func _on_NavigationAgent2D_velocity_computed(safe_velocity: Vector2):
	# Move CharacterBody3D with the computed `safe_velocity` to avoid dynamic obstacles.
	velocity = safe_velocity
	move_and_slide()
