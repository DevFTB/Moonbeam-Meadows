extends Control

var inventory : InventoryComponent
var level: Level 

var campaign_quest_colour = Color.GOLD
var optional_quest_colour = Color.BLUE
var no_quest_colour = Color.GRAY

var quest = null

var submit_callback = null

func ready():
	pass

func set_quest(new_quest: QuestResource):
	quest = new_quest
	$VBoxContainer/NameLabel.text = quest.quest_name
	$VBoxContainer/RequirementsLabel.text = quest.get_requirements_text()
	$VBoxContainer/RewardsLabel.text = quest.get_reward_text()

	$Panel.modulate = campaign_quest_colour if quest.is_campaign_quest else optional_quest_colour
	$VBoxContainer.visible = true
	$VBoxContainer/ClaimButton.disabled = !quest.can_claim(level, inventory)
	pass


func unset_quest():
	quest = null

	$VBoxContainer.visible = false
	$Panel.modulate = no_quest_colour
	submit_callback = null
	pass


func connect_to_claim(callable: Callable):
	if submit_callback == null:
		submit_callback = callable
		$VBoxContainer/ClaimButton.connect("pressed", submit_callback)
	pass # Replace with function body.
