extends Resource
class_name RobotUpgrade

@export var upgrade_name : String
var upgrade_icon : Texture2D:
    get:
        return upgrade_item.item_icon
@export var upgrade_item : InventoryItem
@export var upgrade_properties : Dictionary

func _init(p_upgrade_name = "Upgrade", p_upgrade_item =null, p_upgrade_icon = null, p_upgrade_properties = {}):
    upgrade_name = p_upgrade_name
    upgrade_item = p_upgrade_item
    upgrade_icon = p_upgrade_icon
    upgrade_properties = p_upgrade_properties
