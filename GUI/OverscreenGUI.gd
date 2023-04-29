extends Control
class_name OverscreenGUI

signal opened_menu
signal closed_menu

func update_gui():
	pass

func can_show():
	return not get_parent().get_children().filter(func(x): return x != self).any(func(x): return x.is_active())

func is_active() -> bool:
	return visible	