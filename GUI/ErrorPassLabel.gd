extends Label

@export var error_text = ""
@export var error_settings : LabelSettings

@export var pass_text = ""
@export var pass_settings : LabelSettings

@export var is_error : bool = false

func show_text(errored: bool = true): 
	is_error = errored
	if errored:
		text = error_text
		label_settings = error_settings
	else:
		text = pass_text
		label_settings = pass_settings
	pass