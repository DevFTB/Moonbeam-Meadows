extends VBoxContainer

## A GUI element that displays multiple InventoryButtonLists supporting multiple starting_inventories

signal item_selected(item : InventoryItem, amount : int)

## The starting inventories to display
@export var starting_inventories = []

## Should the interact buttons be visible?
@export var interactable = true

## The scene to use for the list tiles
@export var list_tile_scene : PackedScene

## The text to display on the interact button
@export var button_text = "Place"

var inventories = {}
var inventory_button_list = preload("res://GUI/inventory_button_list.tscn")
var on_build_callback 
func _ready():
	set_inventories(starting_inventories.map(func(x): return get_node(x)))

func set_inventories(new_inventories : Array):
	for inv in new_inventories:
		inventories[inv.inventory_type] = inv
	update_gui()

func update_gui():
	for child in get_children():
		child.queue_free()

	for it in inventories.keys():
		var inventory = inventories[it]
		var new_button_list = inventory_button_list.instantiate() as Control

		if list_tile_scene != null: 
			new_button_list.list_tile_scene = list_tile_scene
		
		if on_build_callback != null:
			new_button_list.on_build_callback = on_build_callback
		new_button_list.interactable = interactable
		new_button_list.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
		new_button_list.set_button_text(button_text)
		new_button_list.set_inventory(inventory)
		new_button_list.button_pressed.connect(_on_item_selected)
		
		add_child(new_button_list)

		configure_button_list(new_button_list)

func configure_button_list(_new_button_list):
	pass


func _on_item_selected(item : InventoryItem, amount :int) -> void:
	item_selected.emit(item, amount)
	pass
