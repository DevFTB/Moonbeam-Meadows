extends Control

@export var quest_manager : Node

var quests = []

const QuestGUI = preload("res://Level/Quests/QuestGUI.gd")

@onready var quest_boxes = $HBoxContainer.get_children()
# Called when the node enters the scene tree for the first time.
func _ready():
	quest_manager.active_quests_updated.connect(_on_active_quests_updated)	
	for qb in quest_boxes:
		qb.unset_quest()	
	pass # Replace with function body.

func _on_active_quests_updated(new_quests):
	set_quests(new_quests)
	pass

func set_quests(new_quests):
	quests = new_quests
	for i in range(quests.size()):
		quest_boxes[i].set_quest(quests[i])
	pass


func _on_phone_gui_opened_menu():
	set_quests(quests)
	pass # Replace with function body.
