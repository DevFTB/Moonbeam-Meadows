extends Control

## A GUI element that displays the upgrades of a robot and allows the user to add/remove them

@export var upgrade_boxes_paths  = []
@export var icon_scene = preload("res://GUI/upgrade_display_icon.tscn")

@onready var upgrade_boxes = upgrade_boxes_paths.map(func(x): return get_node(x))
@onready var energy_station_gui = get_parent()

func _ready():
	energy_station_gui.changed_selected_robot.connect(func(_x): update_gui())

func update_gui():
	var robot = energy_station_gui.selected_robot
	if robot != null:
		for box in upgrade_boxes:
			for child in  box.get_children(): child.queue_free()
	
		for i in range(min(upgrade_boxes.size(), robot.upgrades.size())):
			var icon = icon_scene.instantiate()
			icon.remove_button.pressed.connect(_on_remove_button_pressed)
			icon.set_upgrade(robot.upgrades.values()[i])
			upgrade_boxes[i].add_child(icon)
		
func _on_remove_button_pressed():
	energy_station_gui.remove_upgrade(energy_station_gui.selected_robot.upgrades.values()[0])
	update_gui()