extends Resource 
class_name QuestResource

@export var quest_id = 0

@export var quest_name = "Quest"

@export var is_campaign_quest = true

@export var quest_items : Dictionary = {}

@export var reward_text = "Rewards are nil."

@export var predecessor_quest_ids : Array[int] = []
var rewards: Dictionary = {}
func can_claim(_level : Level, inv_comp : InventoryComponent):
	var inventory = inv_comp.inventory	
	var valid = true
	for q_item in quest_items:
		if not inventory.has(q_item) or inventory[q_item] < quest_items[q_item]:
			
			valid = false
	return valid
# attempts to claim the quest by checking if it can first then removing items from the given inventory.
# returns whether this was successful.
func claim_quest(level: Level, inv_comp: InventoryComponent) -> bool:
	if can_claim(level, inv_comp):
		for q_item in quest_items:
			inv_comp.remove(q_item, quest_items[q_item])
		# give rewards
		
		return true
	else:
		return false

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
