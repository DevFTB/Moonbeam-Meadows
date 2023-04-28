extends CharacterBody2D
class_name Robot

@export var path : Array[Vector2i] = []

@export var pickup_item : InventoryItem

@export var should_deposit = false
@export var should_withdraw = false

@onready var level = get_node("/root/Level") as Level
@onready var inventories = get_children().filter(func(x): return x is InventoryComponent)

@export var base_movement_speed : float = 125
@onready var movement_speed = TrackedModifierValue.new(base_movement_speed)

@export var base_movement_action_penalty : float = 0.25
@onready var movement_action_penalty = TrackedModifierValue.new(base_movement_action_penalty)

@export var base_inventory_capacity : int = 10 
@onready var inventory_capacity = TrackedModifierValue.new(base_inventory_capacity)

@export var base_move_energy_cost  : int = 1
@onready var move_energy_cost = TrackedModifierValue.new(base_move_energy_cost)

@export var base_action_energy_cost : int = 3
@onready var action_energy_cost = TrackedModifierValue.new(base_action_energy_cost)

@export var base_energy_capacity : int = 60
@onready var energy_capacity = TrackedModifierValue.new(base_energy_capacity)

var parent_energy_station = null

var upgrade_counter = 0


class UpgradeInstance:
	extends RefCounted
	var inst_id = 0
	var upgrade : RobotUpgrade
	var property_ids = {}

	func _init(upgrade: RobotUpgrade, inst_id = 0):
		self.upgrade = upgrade
		self.inst_id = inst_id
var upgrades = {}
@export var starting_upgrades = []

var powered = true
var energy = 0

var astar : AStarGrid2D
var path_index = 0
var target_position = null
var is_navigation_finished = true
var direction = Vector2i.ZERO
var temp_path = []
var temp_path_completed = false

var action_directions = [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]
var last_acted = Vector2i.ZERO
var acted_last_tile = false

func _ready():

	$ProximityInteractor.successful_pickup.connect(on_successful_pickup)

	level.traversibility_updated.connect(on_traversability_update)
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
	if is_navigation_finished and powered:
		print("finished navigation")
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
						print("doing action at ", action_position)

				last_acted = current_position
				
		else:
			# temp path doesn't cost energy.
			move_to_grid(temp_path.pop_front())
	else:
		if powered:
		# movement code
			if target_position != null :
	#			if direction == Vector2i.UP or direction == Vector2i.DOWN:
	#				if position.x - 16 % 32 != 0:
	#					position.x = floor(position.x / 32) * 32 + 16
	#			elif direction == Vector2i.LEFT or direction == Vector2i.RIGHT:
	#				if position.y - 16 % 32 != 0:
	#					position.y = floor(position.y / 32) * 32 + 16
				print(acted_last_tile)
				var actual_movement_speed = movement_speed.get_value() if not acted_last_tile else movement_speed.get_value() * movement_action_penalty.get_value()
				var movement_delta = actual_movement_speed * _delta * Vector2(direction)
				var disp = (level.map_to_local(target_position)- Vector2(global_position) + movement_delta).length()
				if disp < 5:
					print("snapping")
					global_position = level.map_to_local(target_position)
					is_navigation_finished = true
				else:
					velocity = actual_movement_speed * direction
					if temp_path_completed and not path.is_empty():
						if not path.has(get_current_position()):
							print("powering down. not on path " , get_current_position())
							power_down()
					move_and_slide()
			else:
				is_navigation_finished = true
				
func can_do_action(grid_position: Vector2i)->bool:
	return false
	
func do_action(grid_position: Vector2i) -> void:
	energy -= action_energy_cost.get_value()
	pass

func power_down():
	powered = false
	$RobotAnimationController.power_down()
	pass

func power_on():
	powered= true
	$RobotAnimationController.power_on()

func check_power():
	if has_energy() and not path.is_empty():
		if not powered:
			power_on()
	else:
		if powered:
			print("powering down. no energy or no path")
			power_down()

func set_path(new_path: Array[Vector2i]):
	path = new_path
	check_power()
	if powered:
		move_to_grid(path[0])

	path_index = 0
	pass
	
func on_move_start():
	pass
	
func snap_to_grid():
	position = level.map_to_local(get_current_position())
	
func move_to_grid(grid_position: Vector2i):
	on_move_start()
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
						print(inv.inventory[item], ", ", max_total_items-total_items)
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

func confirm_deposit(deposit: Dictionary):
	# remove items from inventories according to the deposit
	for item in deposit:
		var inv = inventories.filter(func(x): return x.inventory_type == item.item_type).front()
		var amount = min(inv.get_amount(item), deposit[item])
		inv.remove(item, amount)
		deposit[item] -= amount
		if deposit[item] <= 0:
			break

func get_withdrawal_params():
	var params = {}
	for inv in inventories:
		params[inv.inventory_type] = inv.get_available_capacity()
	return params

func confirm_withdrawal(withdrawal: Dictionary):
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

func add_energy(amount: int) -> void:
	energy = min(energy + amount, energy_capacity.get_value())
	print("added %d energy, now at %d" % [amount, energy])
	check_power()
	pass

func has_energy():
	return energy > 0

func get_energy_requirement():
	return energy_capacity.get_value() - energy 

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
func on_traversability_update(grid_position: Vector2i, traversible: bool):
	astar.set_point_solid(grid_position, not traversible)
func _on_NavigationAgent2D_velocity_computed(safe_velocity: Vector2):
	# Move CharacterBody3D with the computed `safe_velocity` to avoid dynamic obstacles.
	velocity = safe_velocity
	move_and_slide()

func get_current_position() -> Vector2i:
	return level.local_to_map(position)

func on_successful_pickup(interacting_player: Player):
	interacting_player.get_inventory(InventoryItem.ItemType.ROBOT).add(pickup_item, 1)
	remove_self()
	pass

func remove_self():
	if parent_energy_station != null:
		parent_energy_station.remove_robot(self)
	queue_free()

func get_inventory(item_type: InventoryItem.ItemType) -> InventoryComponent:
	var invs = inventories.filter(func(x): return x.inventory_type == item_type)
	if not invs.is_empty():
		return invs.front()
	else:
		return null

func get_specific_description():
	return ""