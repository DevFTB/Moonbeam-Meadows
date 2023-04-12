extends Control

@export var inventory : InventoryComponent
@export var level: Level 

var campaign_quest_colour = Color.GOLD
var optional_quest_color = Color.BLUE

var quest = null

func ready():
	pass



func set_quest(new_quest: QuestResource):
	quest = new_quest
	$VBoxContainer/NameLabel.text = quest.quest_name
	$VBoxContainer/RequirementsLabel.text = quest.get_requirements_text()
	$VBoxContainer/RewardsLabel.text = quest.get_reward_text()

	$Panel.modulate = campaign_quest_colour if quest.is_campaign_quest else optional_quest_color
	$VBoxContainer.visible = true
	$VBoxContainer/ClaimButton.disabled = !quest.can_claim(level, inventory)
	pass


func unset_quest():
	quest = null

	$VBoxContainer.visible = false
	$Panel.modulate = optional_quest_color
	pass
