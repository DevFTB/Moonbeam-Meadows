extends Label

## This is a label that can be used to display a pass or error message.

@export var error_text = ""
@export var error_settings : LabelSettings

@export var pass_text = ""
@export var pass_settings : LabelSettings

@export var is_error : bool = false:
	set(value): 
		is_error = value
		show_text(value)

func show_text(errored: bool = true): 
	if errored:
		text = error_text
		label_settings = error_settings
	else:
		text = pass_text
		label_settings = pass_settings
	pass
