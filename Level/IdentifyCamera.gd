extends Camera2D
var target : Node2D = null 
var cb_cam : Camera2D = null
var following = false

@export var closing_duration = 0.8
@export var follow_duration = 2
signal finished_tracking
func track_target(new_target: Node2D, callback_camera : Camera2D = get_viewport().get_camera_2d()):
	target = new_target
	cb_cam = callback_camera
	var current_cam = get_viewport().get_camera_2d()
	var current_cam_pos = current_cam.global_position

	global_position = current_cam_pos

	enabled = true
	make_current()

	var tween = get_tree().create_tween()
	tween.tween_method(close_on_target.bind(target) ,0.0, 1.0, closing_duration).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT) 
	tween.tween_callback(follow_target)
	tween.tween_callback(stop_follow_target).set_delay(follow_duration)
	tween.tween_method(close_on_target.bind(cb_cam), 0.0, 1.0, closing_duration).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT) 
	tween.tween_callback(stop_tracking)
	pass

func close_on_target(val: float, closing_target: Node2D):
	print(val)
	global_position = global_position.lerp(closing_target.global_position, val)
	
func _process(_delta):
	if following and target != null:
		global_position = target.global_position
		

func follow_target():
	following = true

func stop_follow_target():
	following = false

func stop_tracking():
	cb_cam.make_current()
	enabled = false
	finished_tracking.emit()
