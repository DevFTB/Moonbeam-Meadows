extends Control

@export var campaign_quest_colour = Color.GOLD
@export var optional_quest_colour = Color.BLUE
@export var no_quest_colour = Color.GRAY

var quest_manager = null
var quest = null

func ready():
	pass

func set_quest_manager(new_quest_manager):
	quest_manager = new_quest_manager

func set_quest(new_quest: QuestResource):
	for it in new_quest.quest_items.keys().map(func(x): return x.item_type):
		quest_manager.player.get_inventory(it).inventory_modified.connect(update_gui)
	unset_quest()
	
	quest = new_quest
	$Panel/VBoxContainer/NameLabel.text = quest.quest_name
	$Panel/VBoxContainer/RequirementsLabel.text = quest.get_requirements_text()
	$Panel/VBoxContainer/RewardsLabel.text = quest.get_reward_text()

	$Panel.self_modulate = campaign_quest_colour if quest.is_campaign_quest else optional_quest_colour
	$Panel/VBoxContainer.visible = true
	$Panel/VBoxContainer/ClaimButton.disabled = !quest.can_claim(quest_manager.level, quest_manager.player)
	pass

func update_gui():
	$Panel/VBoxContainer/ClaimButton.disabled = !quest.can_claim(quest_manager.level, quest_manager.player)

func unset_quest():
	if quest != null:
		for it in quest.quest_items.keys().map(func(x): return x.item_type):
			var inv_signal = quest_manager.player.get_inventory(it).inventory_modified
			if inv_signal.is_connected(update_gui):
				inv_signal.disconnect(update_gui)
	quest = null

	$Panel/VBoxContainer.visible = false
	$Panel.self_modulate = no_quest_colour
	

	pass

func _on_claim_button_pressed():
	quest_manager.claim_quest(quest)
	
