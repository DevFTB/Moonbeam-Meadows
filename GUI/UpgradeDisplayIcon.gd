extends Control
var upgrade_inst = null 

@export var texture_rect : TextureRect
@export var remove_button : Button

func set_upgrade(new_upgrade_inst):
    upgrade_inst = new_upgrade_inst

    if upgrade_inst != null:
        texture_rect.texture = upgrade_inst.upgrade.upgrade_icon
        texture_rect.visible = true
        remove_button.visible = true
    else:
        texture_rect.visible = false
        remove_button.visible = false