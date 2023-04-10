extends CharacterBody2D
@export var speed = 125  # speed in pixels/sec

enum Tool {
	TILL, WATER, FERTILISE, HARVEST, 
}

var current_tool = Tool.TILL

func _physics_process(delta):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * speed

	move_and_slide()


func switch_tool(tool : Tool):
	pass

func _input(event):
	if event is InputEventKey:
		if event.is_action_pressed("select_tool1"):
			switch_tool(Tool.TILL)
			pass
		elif event.is_action_pressed("select_tool2"):
			switch_tool(Tool.WATER)
			pass
		elif event.is_action_pressed("select_tool3"):
			switch_tool(Tool.FERTILISE)
			pass
		elif event.is_action_pressed("select_tool4"):
			switch_tool(Tool.HARVEST)
			pass
