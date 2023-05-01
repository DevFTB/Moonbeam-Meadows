extends Sprite2D

## The selection cursor is a sprite that is used to select tiles on the map.

@export var player : Player

var selection = Vector2.ZERO

func _ready():
	player.freeze_changed.connect(_on_freeze_changed)
	pass

func _input(event):
	if event is InputEventMouseButton:
		if event.is_action_pressed("use_item"):
			player.use_tool(get_selection())
	if event is InputEventMouseMotion:
		calculate_selection()	

func calculate_selection():
	var mouse_position = get_global_mouse_position()
	var offset_angle = (mouse_position - player.global_position).angle() + PI  /8
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
	
	selection =get_parent().local_to_map(player.position ) + Vector2i(cangle)
	position = get_parent().map_to_local(selection)

func get_selection():
	# check if selection is still valid
	calculate_selection()
	return selection


func _on_freeze_changed(freeze):
	if freeze:
		hide()
	else:
		show()
