extends Resource
class_name TrackedModifierValue

## A value that can be modified by multiple sources, and tracks the modifiers

## The mode to use when applying modifiers.
## ADDITIVE: The value is the sum of all modifiers.
## MULTIPLICATIVE: The value is the product of all modifiers.
enum ModifierMode { ADDITIVE = 0, MULTIPLICATIVE = 1 }

@export var base_value := 1.0

## The mode to use when applying modifiers.
@export var modifier_mode : ModifierMode = ModifierMode.ADDITIVE

## An incrementing counter used to track modifiers.
var counter = 0
var modifiers = {}

func _init(p_base_value = 1.0, p_modifier_mode = ModifierMode.ADDITIVE):
	base_value = p_base_value
	modifier_mode = p_modifier_mode

## Returns the current value of the tracked value, after applying all modifiers.
func get_value() -> float:
	match(modifier_mode):
		ModifierMode.ADDITIVE:
			return modifiers.values().reduce(func(a,b): return a + b, base_value)
		ModifierMode.MULTIPLICATIVE:
			return modifiers.values().reduce(func(a,b): return a * b, base_value)

	return base_value

## Adds a modifier to the tracked value, and returns the id of the modifier.
func add_modifier(value: float) -> int:
	counter += 1

	modifiers[counter] = value
	return counter

## Removes a modifier from the tracked value.
func remove_modifier(id: int) -> void:
	if modifiers.has(id):
		modifiers.erase(id)

