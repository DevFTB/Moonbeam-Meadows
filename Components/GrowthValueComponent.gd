extends Node

## A value that can be depleted and refilled over time

## Emits when the value hits 0
signal depleted

## Emits when the value hits the maximum value. This will not be emitted if the maximum value is -1
signal maximum_reached

@export var starting_value := 0.0;
# set to -1 if infinite
@export var maximum_value := 100.0

@export var growth_per_second := 1.0

@onready var value = starting_value

func _process(delta):
    var change = growth_per_second * delta

    # if the value is decreasing, make sure it doesn't go below 0
    if growth_per_second < 0:
        if value > 0:
            value += change
            if value < 0:
                depleted.emit()
                value = 0
    else:
        # if the value is increasing, make sure it doesn't go above the maximum value (if it's not -1)
        if maximum_value > 0 and value >= maximum_value:
            maximum_reached.emit()
            value = maximum_value
        else:
            value += change

## Withdraws the amount from the value, the amount must be less than or equal to the value to be successful
## Returns true if the amount was withdrawn, false if it was not
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

## Returns the current value or 0 if the maximum value is 0 or lower
func get_percentage() -> float:
    if maximum_value <= 0:
        return 0.0

    return value / maximum_value
## Returns the time it will take to fill the value, or -1 if it is infinite
func get_time_to_fill() -> float:
    if growth_per_second == 0:
        return 0.0

    if growth_per_second < 0:
        return value / -growth_per_second

    if maximum_value <= 0:
        return -1.0

    return (maximum_value - value) / growth_per_second