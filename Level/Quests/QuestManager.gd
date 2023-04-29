extends Node

signal active_quests_updated(quests)

@export var quests : Array[QuestResource] = []
@export var player: Player 

var active_quests = []
var completed_quests = []

@onready var level = get_parent()
# Called when the node enters the scene tree for the first time.
func _ready():
	var initial_quests = get_candidate_quests(true)

	for quest in initial_quests:
		activate_quest(quest)

## Claims a quest and removes it from the quest pool. If its a campaign quest, it will also activate any new quests that are unlocked by completing this quest
func claim_quest(quest: QuestResource): 
	if quest.claim_quest(level, player):
		completed_quests.append(quest)
		active_quests.erase(quest)

		# Check if there are any new quests to activate
		if quest.is_campaign_quest:
			for cq in get_candidate_quests(true):
				activate_quest(cq)
		
		active_quests_updated.emit(active_quests)

## Activates a quest and adds it to the active quest pool
func activate_quest(quest: QuestResource):
	if quest in active_quests:
		return

	
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
