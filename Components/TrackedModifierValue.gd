extends Resource
class_name TrackedModifierValue

@export var base_value = 1.0
@export var modifier_mode : ModifierMode = ModifierMode.ADDITIVE

var counter = 0

var modifiers = {}
enum ModifierMode {
	ADDITIVE = 0,
	MULTIPLICATIVE = 1
}

func get_value() -> float:
	match(modifier_mode):
		ModifierMode.ADDITIVE:
			return modifiers.values().reduce(func(a,b): return a + b, base_value)
		ModifierMode.MULTIPLICATIVE:
			return modifiers.values().reduce(func(a,b): return a * b, base_value)

	return base_value

func add_modifier(value: float) -> int:
	counter += 1

	modifiers[counter] = value
	return counter

func remove_modifier(id: int) -> void:
	if modifiers.has(id):
		modifiers.erase(id)

func _init(p_base_value = 1.0, p_modifier_mode = ModifierMode.ADDITIVE):
	base_value = p_base_value
	modifier_mode = p_modifier_mode
