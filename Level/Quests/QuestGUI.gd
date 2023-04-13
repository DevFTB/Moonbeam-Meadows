extends Control

var quest_manager = null

var campaign_quest_colour = Color.GOLD
var optional_quest_colour = Color.BLUE
var no_quest_colour = Color.GRAY

var quest = null

func ready():
	pass

func set_quest_manager(new_quest_manager):
	quest_manager = new_quest_manager

func set_quest(new_quest: QuestResource):
	unset_quest()
	
	quest = new_quest
	$VBoxContainer/NameLabel.text = quest.quest_name
	$VBoxContainer/RequirementsLabel.text = quest.get_requirements_text()
	$VBoxContainer/RewardsLabel.text = quest.get_reward_text()

	$Panel.modulate = campaign_quest_colour if quest.is_campaign_quest else optional_quest_colour
	$VBoxContainer.visible = true
	$VBoxContainer/ClaimButton.disabled = !quest.can_claim(quest_manager.level, quest_manager.player)
	pass


func unset_quest():
	quest = null

	$VBoxContainer.visible = false
	$Panel.modulate = no_quest_colour
	

	pass


func _on_claim_button_pressed():
	quest_manager.claim_quest(quest)
	pass # Replace with function body.
