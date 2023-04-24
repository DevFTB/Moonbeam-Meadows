extends Node

@export var starting_value = 0.0;
# set to -1 if infinite
@export var maximum_value = 100.0

@export var growth_per_second = 1.0

@onready var value = starting_value

signal depleted
signal maximum_reached

func _process(delta):
    var change = growth_per_second * delta

    if growth_per_second < 0:
        if value > 0:
            value += change
            if value < 0:
                depleted.emit()
                value = 0
    else:
        if maximum_value > 0 and value >= maximum_value:
            maximum_reached.emit()
            value = maximum_value
        else:
            value += change

func withdraw(amount: float) -> bool:
    if amount > value:
        return false

    value -= amount
    return true

# adds the amount to the value, allowing the value to exceed the maximum value if allow_overflow is true
# returns true if the amount was added, false if it was not
func add(amount: float, allow_overflow: bool = false) -> bool:
    if not allow_overflow and maximum_value > 0 and value + amount > maximum_value:
        return false

    value += amount
    return true

func get_percentage():
    if maximum_value <= 0:
        return 0.0

    return value / maximum_value