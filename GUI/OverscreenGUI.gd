extends Control
class_name OverscreenGUI

## A GUI that is shown over the game screen exclusively

signal opened_menu
signal closed_menu

func _ready():
	hide_all()

func update_gui():
	pass

func hide_all():
	hide()

func can_show():
	return not get_parent().get_children().filter(func(x): return x != self).any(func(x): return x.is_active())

func is_active() -> bool:
	return visible	