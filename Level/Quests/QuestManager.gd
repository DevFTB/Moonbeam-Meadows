extends Node

@export var quests : Array[QuestResource] = []

@export var player_inventory : InventoryComponent
var level = get_parent()

signal active_quests_updated(quests)

var active_quests = []
var completed_quests = []

# Called when the node enters the scene tree for the first time.
func _ready():
	var initial_quests = get_candidate_quests(true)

	for quest in initial_quests:
		activate_quest(quest)
	pass # Replace with function body.

func claim_quest(quest: QuestResource): 
	if quest.claim_quest(level, player_inventory):
		completed_quests.append(quest)
		active_quests.erase(quest)
		if quest.is_campaign_quest:
			for cq in get_candidate_quests(true):
				activate_quest(cq)

	else:
		print("Quest %s not completed" % quest.quest_id)
	pass

func activate_quest(quest: QuestResource):
	if quest in active_quests:
		return

	print("Activating quest: %s " % quest.quest_id) 
	active_quests.append(quest)
	active_quests_updated.emit(active_quests)

# Returns all quests which precedessors have been completed
func get_candidate_quests(campaign_only = false):
	var candidate_quests = []
	for quest in quests:
		if not completed_quests.has(quest) and (not campaign_only or quest.is_campaign_quest) and quest.has_predecessors(completed_quests.map(func (x): return x.quest_id)):
			candidate_quests.append(quest)
	return candidate_quests

func get_active_quests():
	return active_quests
