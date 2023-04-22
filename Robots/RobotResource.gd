extends Resource
class_name RobotResource

@export var robot_type_name : String
@export var robot_description : String

@export var robot_icon : Texture2D

@export var robot_item : InventoryItem
@export var entity_scene: PackedScene

func get_icon() -> Texture2D:
    return robot_icon

func get_type_name() -> String:
    return robot_type_name


func _init(p_robot_type_name = "Robot", p_robot_description = "A robot", p_robot_icon = null, p_robot_item = null, p_entity_scene = null):
    robot_type_name = p_robot_type_name
    robot_description = p_robot_description
    robot_icon = p_robot_icon
    robot_item = p_robot_item
    entity_scene = p_entity_scene
    pass

func generate_entity() -> Node2D:
    var new_robot = entity_scene.instantiate()
    new_robot.pickup_item = robot_item
    return new_robot
