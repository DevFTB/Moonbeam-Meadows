extends Label

@export var currency_manager : Node

# Called when the node enters the scene tree for the first time.
func _ready():
	currency_manager.currency_changed.connect(update_currency)
	pass # Replace with function body.

func update_currency(new_value: int):
	text = str(new_value)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
