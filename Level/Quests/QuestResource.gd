extends Resource 
class_name QuestResource

@export var quest_id :int

@export var quest_name : String

@export var is_campaign_quest : bool

@export var quest_items : Dictionary 

@export var reward_text : String

@export var rewards : Array[QuestReward]

@export var predecessor_quest_ids : Array[int]

func _init(p_quest_id = 0, p_quest_name = "Quest", p_is_campaign_quest = true, p_quest_items : Dictionary = {}, p_reward_text = "Rewards are nil.", p_rewards : Array[QuestReward] = [], p_predecessor_quest_ids : Array[int] = []):
	quest_id = p_quest_id
	quest_name = p_quest_name
	is_campaign_quest = p_is_campaign_quest
	quest_items = p_quest_items
	reward_text = p_reward_text
	rewards = p_rewards
	predecessor_quest_ids = p_predecessor_quest_ids

func can_claim(_level : Level, player: Player):
	var valid = true
	for q_item in quest_items:
		var inventory = player.get_inventory(q_item.item_type)
		print("Can Claim: Inventory has item? %s %s" % [q_item.item_name, inventory.has_item(q_item)])
		print("Can Claim: Inventory amount: %s %d" % [inventory.inventory_type, inventory.get_amount(q_item)])
		print("Can Claim: Quest item amount: %d" % [quest_items[q_item]])
		if not inventory.has_item(q_item) or inventory.get_amount(q_item) < quest_items[q_item]:
			valid = false
	return valid
# attempts to claim the quest by checking if it can first then removing items from the given inventory.
# returns whether this was successful.
func claim_quest(level: Level, player: Player) -> bool:
	if can_claim(level, player):
		for q_item in quest_items:
			var inventory = player.get_inventory(q_item.item_type)
			inventory.remove(q_item, quest_items[q_item])

		# give rewards
		apply_rewards(level, player)
		
		return true
	else:
		return false

func apply_rewards(level: Level, player: Player):
	for r in rewards:
		r.apply_rewards(level, player)
	pass

# Returns whether all predecessor quests ids are in the given array of quest ids.
func has_predecessors(quest_ids) -> bool:
	for pred_id in predecessor_quest_ids:
		if pred_id not in quest_ids:
			return false
	return true

func get_requirements_text():
	var req_test = "Requirements: \n"
	for item in quest_items.keys():
		req_test += "%dx %s" % [quest_items[item], item.item_name]
	return req_test

func get_reward_text():
	var reward_text = "Rewards: \n"
	for r in rewards:
		reward_text += r.get_reward_text() + "\n"
	return reward_text

func get_display_name():
	return quest_name
