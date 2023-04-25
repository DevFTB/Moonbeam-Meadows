extends CharacterBody2D
class_name Robot

@export var movement_speed: float = 125.0
@export var movement_penalty : float = 0.25
@export var move_energy_cost = 1
@export var action_energy_cost = 3
@export var path : Array[Vector2i] = []
@export var energy_capacity = 30

@export var pickup_item : InventoryItem

@export var should_deposit = false
@export var should_withdraw = false

var path_index = 0
var powered = true

var last_acted = Vector2i.ZERO

@onready var energy = energy_capacity
@onready var level = get_node("/root/Level") as Level
@onready var inventories = get_children().filter(func(x): return x is InventoryComponent)

var action_directions = [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]

var target_position = null
var is_navigation_finished = true

var direction = Vector2i.ZERO
var temp_path = []

var parent_energy_station = null

var astar : AStarGrid2D

var acted_last_tile = false
var temp_path_completed = false

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

	pass	
	
func _physics_process(_delta):
	if is_navigation_finished:
		acted_last_tile = false
		# check if should power down
		if powered:
			if not has_energy() or path.size() <= 1:
				power_down()
				return

			# travelling temp path overrides normal path
			if temp_path.is_empty():
				temp_path_completed  = true
				# start moving to next grid in path if possible
				if energy >= move_energy_cost:
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
						if can_do_action(action_position) and energy >= action_energy_cost:
							do_action(action_position)
							acted_last_tile = true

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
				var actual_movement_speed = movement_speed if not acted_last_tile else movement_speed * movement_penalty 
				var movement_delta = actual_movement_speed * _delta * Vector2(direction)
				var disp = (level.map_to_local(target_position)- Vector2(global_position) + movement_delta).length()
				if disp < 5:
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
	energy -= action_energy_cost
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
			energy -= move_energy_cost
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
	energy = min(energy + amount, energy_capacity)
	print("added %d energy, now at %d" % [amount, energy])
	check_power()
	pass

func has_energy():
	return energy > 0

func get_energy_requirement():
	return energy_capacity - energy 

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
