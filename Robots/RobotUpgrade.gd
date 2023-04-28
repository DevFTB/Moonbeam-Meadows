extends Resource
class_name RobotUpgrade

@export var upgrade_name : String
var upgrade_icon : Texture2D:
    get:
        return upgrade_item.item_icon
@export var upgrade_item : InventoryItem
@export var upgrade_properties : Dictionary

func _init(upgrade_name = "Upgrade", upgrade_item =null, upgrade_icon = null, upgrade_properties = {}):
    self.upgrade_name = upgrade_name
    self.upgrade_item = upgrade_item 
    self.upgrade_icon = upgrade_icon
    self.upgrade_properties = upgrade_properties

