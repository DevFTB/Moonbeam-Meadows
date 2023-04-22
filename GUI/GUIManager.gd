extends Control

@export var exclusive_gui_screens : Array[Control]
@onready var player = get_tree().get_first_node_in_group('player')
# Called when the node enters the scene tree for the first time.
func _ready():
	for gui in $OverscreenUI.get_children():
		gui.opened_menu.connect(func(): player.freeze())
		gui.closed_menu.connect(func(): player.unfreeze())
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
