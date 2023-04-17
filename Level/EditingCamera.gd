extends Camera2D

@export var speed = 100

var other_camera : Camera2D = null

func _process(delta):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	position += direction * speed * delta

func enable():
	other_camera = get_viewport().get_camera_2d()
	other_camera.enabled = false
	self.enabled = true
	self.make_current()

func disable():
	other_camera.enabled = true
	other_camera.make_current()
	self.enabled = false

