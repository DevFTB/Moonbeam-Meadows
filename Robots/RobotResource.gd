extends Resource
class_name RobotResource

@export var robot_type_name : String
@export var robot_description : String

@export var robot_icon : Texture2D

@export var robot_energy_capacity : int

func get_icon() -> Texture2D:
    return robot_icon

func get_type_name() -> String:
    return robot_type_name


func _init(p_robot_type_name = "Robot", p_robot_description = "A robot", p_robot_icon = null, p_robot_energy_capacity = 60):
    robot_type_name = p_robot_type_name
    robot_description = p_robot_description
    robot_icon = p_robot_icon
    robot_energy_capacity = p_robot_energy_capacity
    pass