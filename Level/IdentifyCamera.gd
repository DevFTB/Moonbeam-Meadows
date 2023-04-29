extends Camera2D

# This camera is used to track a target node, and then return to the camera that was being used before

signal finished_tracking

@export var closing_duration = 0.8
@export var follow_duration = 2

var target : Node2D = null 
var cb_cam : Camera2D = null
var following = false

func _process(_delta):
	if following and target != null:
		global_position = target.global_position
		
## Initiates the tracking of a target node
func track_target(new_target: Node2D, callback_camera : Camera2D = get_viewport().get_camera_2d()):
	target = new_target
	cb_cam = callback_camera
	var current_cam = get_viewport().get_camera_2d()
	var current_cam_pos = current_cam.global_position

	global_position = current_cam_pos

	enabled = true
	make_current()

	var tween = get_tree().create_tween()
	tween.tween_method(_close_on_target.bind(target) ,0.0, 1.0, closing_duration).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT) 
	tween.tween_callback(_follow_target)
	tween.tween_callback(_stop_follow_target).set_delay(follow_duration)
	tween.tween_method(_close_on_target.bind(cb_cam), 0.0, 1.0, closing_duration).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT) 
	tween.tween_callback(_stop_tracking)
	pass

func _close_on_target(val: float, closing_target: Node2D):
	global_position = global_position.lerp(closing_target.global_position, val)
	
func _follow_target():
	following = true

func _stop_follow_target():
	following = false

func _stop_tracking():
	cb_cam.make_current()
	enabled = false
	finished_tracking.emit()
