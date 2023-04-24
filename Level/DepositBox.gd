extends "res://Level/Trade Station/InteractableConstruction.gd"
class_name DepositBox
@export var receiving_items : bool = true
@export var providing_items : bool = false

@export var max_items : int = 60
@export var max_unique_items : int = 10

@export var item_types : Array[InventoryItem.ItemType] = [InventoryItem.ItemType.PRODUCE]
var inventories = []
@export var initial_items : Dictionary = {}
func _ready():
	for item_type in item_types:
		var inv_comp = InventoryComponent.new()
		inv_comp.inventory_type = item_type
		add_child(inv_comp)
		inventories.append(inv_comp)
	
	for item in initial_items.keys():
		var inv_comp = get_inventory(item.item_type)
		inv_comp.add(item, initial_items[item])
	
		
func get_inventory(item_type : InventoryItem.ItemType) -> InventoryComponent:
	return inventories[inventories.find(func(x) : return x.inventory_type == item_type)]
func set_gui_owner():
	gui.set_deposit_box(self)

func _on_robot_interactor_robot_exited(_robot:Robot):
	pass # Replace with function body.

func _on_robot_interactor_robot_entered(robot:Robot):
	if receiving_items and robot.should_deposit: ask_for_deposit(robot)
	if providing_items and robot.should_withdraw: ask_for_withdrawal(robot)

func ask_for_deposit(robot:Robot):
	var unique_items = max_unique_items - get_amount_of_unique_items()
	var items = max_items - get_amount_of_items()
	if unique_items <= 0 or items <= 0: return
	var deposit = robot.generate_deposit(item_types, unique_items, items)
	if consume_deposit(deposit):
		robot.confirm_deposit(deposit)
	pass # Replace with function body.

func consume_deposit(deposit:Dictionary):
	for it in item_types:
		var items = deposit.keys().filter(func(x) : return x.item_type == it)
		var inventory = get_inventory(it)

		for item in items:
			inventory.add(item, deposit[item])

	return true
	
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

func consume_withdrawal(withdrawal:Dictionary):
	for item in withdrawal.keys():
		var inventory = get_inventory(item.item_type)
		inventory.remove(item, withdrawal[item])
	pass # Replace with function body.
func get_amount_of_unique_items() -> int:
	var unique_items : int = 0
	for child in inventories:
		unique_items += child.get_amount_of_unique_items() 
	return unique_items

func get_amount_of_items():
	var total_items : int = 0
	for child in inventories:
		total_items += child.get_amount_of_items() 
	return total_items

func transfer_to_player(item, amount):
	if get_inventory(item.item_type).remove(item, amount):
		interacting_player.get_inventory(item.item_type).add(item, amount)

