extends AnimatedSprite2D

func _ready():
	animation_finished.connect(on_animation_finished)
	pass
func power_down():
	play("power_down")
	pass

func power_on():
	play("power_up")
	pass

func on_animation_finished():
	print(animation)
	if animation == "power_down":
		play("unpowered")
	if animation == "power_up":
		play("powered")
	pass