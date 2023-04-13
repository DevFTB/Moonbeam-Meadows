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
	var inventory = player.get_node("ProduceInventory").inventory
	var valid = true
	for q_item in quest_items:
		if not inventory.has(q_item) or inventory[q_item] < quest_items[q_item]:
			valid = false
	return valid
# attempts to claim the quest by checking if it can first then removing items from the given inventory.
# returns whether this was successful.
func claim_quest(level: Level, player: Player) -> bool:
	var inv_comp = player.get_node("ProduceInventory")
	if can_claim(level, player):
		for q_item in quest_items:
			inv_comp.remove(q_item, quest_items[q_item])

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
		req_test += "%dx %s" % [quest_items[item], item.get_display_name()]
	print("sdf " + req_test)
	return req_test

func get_reward_text():
	return reward_text

func get_display_name():
	return quest_name
