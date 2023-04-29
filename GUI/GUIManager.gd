extends Control

@export var exclusive_gui_screens : Array[Control]
@onready var player = get_tree().get_first_node_in_group('player')

func _ready():
	for gui in $OverscreenUI.get_children():
		gui.opened_menu.connect(func(): player.freeze())
		gui.closed_menu.connect(func(): player.unfreeze())
		gui.hide()
