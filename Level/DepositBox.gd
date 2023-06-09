extends "res://Level/Trade Station/InteractableConstruction.gd"
class_name DepositBox

## Is the box currently receiving items from robots?
@export var receiving_items : bool = true

## Is the box currently providing items to robots?j
@export var providing_items : bool = false

## The maximum amount of items that can be stored in the box
@export var max_items : int = 60

## The maximum amount of unique items that can be stored in the box
@export var max_unique_items : int = 10

## The types of items that can be stored in the boxj
@export var item_types : Array[InventoryItem.ItemType] = [InventoryItem.ItemType.PRODUCE]

## The items that the box starts with
@export var initial_items : Dictionary = {}

var inventories = {}

func _ready():
	for item_type in item_types:
		var inv_comp = InventoryComponent.new()
		inv_comp.inventory_type = item_type
		inv_comp.inventory_size = max_items
		add_child(inv_comp)
		inventories[item_type] = inv_comp
	
	for item in initial_items.keys():
		var inv_comp = get_inventory(item.item_type)
		inv_comp.add(item, initial_items[item])
	
## Transfer an item from the box to the player		
func transfer_to_player(item, amount):
	var p_inv = interacting_player.get_inventory(item.item_type)
	var b_inv = get_inventory(item.item_type)
	var transfer_amount = min(amount, p_inv.get_available_capacity())
	if b_inv.remove(item, transfer_amount):
		p_inv.add(item, transfer_amount)
## Transfer an item from the player to the box
func transfer_to_box(item, amount):
	var p_inv = interacting_player.get_inventory(item.item_type)
	var b_inv = get_inventory(item.item_type)
	var transfer_amount = min(amount, b_inv.get_available_capacity())
	if p_inv.remove(item, transfer_amount):
		b_inv.add(item, transfer_amount)
## Asks the given robot to deposit items into the box with the box's current constraints 
func ask_for_deposit(robot:Robot):
	var unique_items = max_unique_items - get_amount_of_unique_items()
	var items = max_items - get_amount_of_items()
	if unique_items <= 0 or items <= 0: return
	var deposit = robot.generate_deposit(item_types, unique_items, items)
	if consume_deposit(deposit):
		robot.confirm_deposit(deposit)
	
## Accepts the deposit from the robot, and adds the items to the box
func consume_deposit(deposit:Dictionary):
	for it in item_types:
		var items = deposit.keys().filter(func(x) : return x.item_type == it)
		var inventory = get_inventory(it)

		for item in items:
			inventory.add(item, deposit[item])

	return true

## Asks the given robot to withdraw items from the box with the box's current constraints	
func ask_for_withdrawal(robot:Robot):
	var wd_params = robot.get_withdrawal_params()
	
	var withdrawal = {}	
	for it in wd_params.keys():
		var request_amount = wd_params[it]
		var inventory = get_inventory(it)

		if inventory == null: continue
		for item in inventory.inventory.keys():
			if request_amount <= 0: break
			var amount_to_withdraw = min(request_amount, inventory.get_amount(item))
			withdrawal[item] = amount_to_withdraw
			request_amount -= amount_to_withdraw
	
	if robot.confirm_withdrawal(withdrawal):
		consume_withdrawal(withdrawal)

	return withdrawal

## Accepts the withdrawal from the robot, and removes the items from the box
func consume_withdrawal(withdrawal:Dictionary):
	for item in withdrawal.keys():
		var inventory = get_inventory(item.item_type)
		inventory.remove(item, withdrawal[item])
	
	
func get_amount_of_unique_items() -> int:
	var unique_items : int = 0
	for child in inventories.values():
		unique_items += child.get_amount_of_unique_items() 
	return unique_items

func get_amount_of_items():
	var total_items : int = 0
	for child in inventories.values():
		total_items += child.get_amount_of_items() 
	return total_items

func get_inventory(item_type : InventoryItem.ItemType) -> InventoryComponent:
	return inventories[item_type]
func set_gui_owner():
	gui.set_deposit_box(self)


func _on_robot_interactor_robot_exited(_robot:Robot):
	pass	

func _on_robot_interactor_robot_entered(robot:Robot):
	if receiving_items and robot.should_deposit: ask_for_deposit(robot)
	if providing_items and robot.should_withdraw: ask_for_withdrawal(robot)
