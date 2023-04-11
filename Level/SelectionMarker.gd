extends Sprite2D

@export var reference_node : Node2D


var selection = Vector2.ZERO

func get_selection():
	# check if selection is still valid
	calculate_selection()
	return selection

func calculate_selection():
	var mouse_position = get_global_mouse_position()
	var offset_angle = (mouse_position - reference_node.global_position).angle() + PI  /8
	var cangle = Vector2.ZERO
	
	if offset_angle >= 0 and offset_angle < PI / 4 :
		cangle = Vector2(1,0)
	elif offset_angle >= PI / 4 and offset_angle < PI  / 2 :
		cangle = Vector2(1, 1)
	elif offset_angle >= PI / 2 and offset_angle < 3 * PI  / 4 :
		cangle = Vector2(0, 1)
	elif offset_angle >= 3 * PI / 4 and offset_angle < PI:
		cangle = Vector2(-1,1)
	elif offset_angle >= -PI  / 4 and offset_angle < 0 :
		cangle = Vector2(1,-1)
	elif offset_angle >= -PI / 2 and offset_angle < -PI  / 4 :
		cangle = Vector2(0,-1)
	elif offset_angle >= - 3 * PI / 4 and offset_angle < -PI  / 2 :
		cangle = Vector2(-1,-1)
	else:
		cangle = Vector2(-1,0)
	
	selection =get_parent().local_to_map(reference_node.position ) + Vector2i(cangle)
	position = get_parent().map_to_local(selection)


func _input(event):
	if event is InputEventMouseButton:
		if event.is_action_pressed("use_item"):
			reference_node.use_tool(get_selection())
	if event is InputEventMouseMotion:
		calculate_selection()	