extends Control

const QuestGUI = preload("res://Level/Quests/QuestGUI.gd")

@export var quest_manager : Node
@export var quest_box_parent : Control

var quests = []

@onready var quest_boxes = quest_box_parent.get_children()
# Called when the node enters the scene tree for the first time.
func _ready():
	quest_manager.active_quests_updated.connect(_on_active_quests_updated)	
	for qb in quest_boxes:
		qb.quest_manager = quest_manager
		qb.unset_quest()
	

func set_quests(new_quests):
	quests = new_quests
	for qb in quest_boxes:
		qb.unset_quest()
		
	for i in range(quests.size()):
		quest_boxes[i].set_quest(quests[i])

func _on_active_quests_updated(new_quests):
	set_quests(new_quests)