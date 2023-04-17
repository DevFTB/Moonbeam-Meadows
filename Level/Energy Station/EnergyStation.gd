extends InteractableConstruction

@onready var robots = get_tree().get_nodes_in_group("robot")

# Called when the node enters the scene tree for the first time.
func _ready():
	gui.set_robots(robots)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
