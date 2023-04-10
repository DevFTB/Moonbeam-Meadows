extends CharacterBody2D
@export var speed = 125  # speed in pixels/sec

signal tool_changed(new_tool: Tool)

enum Tool {
	TILL, WATER, FERTILISE, HARVEST, 
}

var current_tool = Tool.TILL

var facing = Vector2.DOWN

func _physics_process(delta):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	facing = direction.normalized()
	velocity = direction * speed

	move_and_slide()

func switch_tool(tool : Tool):
	if current_tool != tool:
		current_tool = tool
		# play tool switching sound
		# update tool GUI
		tool_changed.emit(current_tool)
		
	pass
	
func use_tool(grid_position):
	match(current_tool):
		Tool.TILL:
			get_parent().till_land(grid_position)
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
