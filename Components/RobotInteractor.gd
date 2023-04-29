extends Node2D

## A node that detects when a robot enters or exits the interact area which is a square of tiles around the position of the node.

## A robot has entered the interact area
signal robot_entered(robot: Robot)

## A robot has exited the interact area
signal robot_exited(robot: Robot)

## The range of the interact area. 1 covers the eight tiles around the position, 2 covers the 24 tiles around the position, etc.
@export var interact_range = 2

# Draws the interact area in the game if true
@export var debug_draw = false:
	get:
		return debug_draw
	set(value):
		debug_draw = value
		queue_redraw()

var area = null
var shape = null

## The robots currently in the interact area
var robots = []

func _ready():
	# Directly interacts with the physics server to establish the interact area
	var space = get_world_2d().space

	shape = PhysicsServer2D.rectangle_shape_create()
	var size = Vector2(interact_range*32*2 + 32, interact_range*32*2 + 32)
	PhysicsServer2D.shape_set_data(shape, size / 2)

	area = PhysicsServer2D.area_create()
	PhysicsServer2D.area_set_collision_mask(area, 0b10)
	PhysicsServer2D.area_set_monitor_callback(area, _on_body_interacted)    
	PhysicsServer2D.area_set_transform(area, get_global_transform())
	
	PhysicsServer2D.area_add_shape(area, shape)
	PhysicsServer2D.area_set_space(area, space)
	
	pass

func _exit_tree():
	PhysicsServer2D.area_set_space(area, RID())

func _on_body_interacted(status, _body_rid, instance_id, _body_shape_idx, _self_shape_idx):
	if status == PhysicsServer2D.AREA_BODY_ADDED:
		var robot = instance_from_id(instance_id) as Robot
		if robot != null:
			robots.append(robot)
			robot_entered.emit(robot)
	elif status == PhysicsServer2D.AREA_BODY_REMOVED:
		var robot = instance_from_id(instance_id) as Robot
		if robot != null:
			robots.erase(robot)
			robot_exited.emit(robot)
			
	pass

func _draw():
	if debug_draw:
		draw_rect(Rect2(-interact_range*32 - 16, -interact_range*32 - 16, interact_range*32*2 + 32, interact_range*32*2 + 32), Color(1, 0, 0, 0.5))

## Updates the shape of the interact area to match the new interact range
func update_range(new_ir):
	interact_range = new_ir
	
	var size = Vector2(interact_range*32*2 + 32, interact_range*32*2 + 32)
	PhysicsServer2D.shape_set_data(shape, size / 2)

