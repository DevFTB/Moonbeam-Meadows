extends Control

@onready var energy_station_gui = get_parent()
@export var upgrade_boxes_paths  = []
@onready var upgrade_boxes = upgrade_boxes_paths.map(func(x): return get_node(x))
@export var icon_scene = preload("res://GUI/upgrade_display_icon.tscn")

func _ready():
	energy_station_gui.changed_selected_robot.connect(func(_x): update_gui())

func update_gui():
	print("updaing_gui")
	var robot = energy_station_gui.selected_robot
	if robot != null:
		for box in upgrade_boxes:
			for child in  box.get_children(): child.queue_free()
	
		for i in range(min(upgrade_boxes.size(), robot.upgrades.size())):
			var icon = icon_scene.instantiate()
			icon.remove_button.pressed.connect(
				func(): 
					energy_station_gui.remove_upgrade(robot.upgrades.values()[i])
					update_gui()
			)
			icon.set_upgrade(robot.upgrades.values()[i])
			upgrade_boxes[i].add_child(icon)
