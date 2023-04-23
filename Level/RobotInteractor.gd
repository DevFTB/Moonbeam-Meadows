extends Node2D

@export var interact_range = 2
var area = null
var shape = null

@export var debug_draw = false:
	get:
		return debug_draw
	set(value):
		debug_draw = value
		queue_redraw()
var robots = []

signal robot_entered(robot: Robot)
signal robot_exited(robot: Robot)

func _ready():
	var space = get_world_2d().space


	shape = PhysicsServer2D.rectangle_shape_create()
	var size = Vector2(interact_range*32*2 + 32, interact_range*32*2 + 32)
	PhysicsServer2D.shape_set_data(shape, size / 2)

	area = PhysicsServer2D.area_create()
	PhysicsServer2D.area_set_collision_mask(area, 0b10)
	PhysicsServer2D.area_set_monitor_callback(area, on_body_entered)    
	PhysicsServer2D.area_set_transform(area, get_global_transform())
	
	PhysicsServer2D.area_add_shape(area, shape)
	PhysicsServer2D.area_set_space(area, space)
	
	pass

func _exit_tree():
	PhysicsServer2D.area_set_space(area, RID())
	


func on_body_entered(status, body_rid, _instance_id, _body_shape_idx, _self_shape_idx):
	if status == PhysicsServer2D.AREA_BODY_ADDED:
		var body_id = PhysicsServer2D.body_get_object_instance_id(body_rid)
		var robot = instance_from_id(body_id) as Robot
		if robot != null:
			robots.append(robot)
			robot_entered.emit(robot)
			print(robot)
	elif status == PhysicsServer2D.AREA_BODY_REMOVED:
		var body_id = PhysicsServer2D.body_get_object_instance_id(body_rid)
		var robot = instance_from_id(body_id) as Robot
		if robot != null:
			robots.erase(robot)
			robot_exited.emit(robot)
			print(robot)
	pass

func _draw():
	if debug_draw:
		draw_rect(Rect2(-interact_range*32 - 16, -interact_range*32 - 16, interact_range*32*2 + 32, interact_range*32*2 + 32), Color(1, 0, 0, 0.5))
