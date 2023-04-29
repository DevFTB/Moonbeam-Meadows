extends Area2D

signal successful_pickup(interacting_player: Player)

@export var duration_of_interaction = 1.0

var pickup_timer = 0.0
var picking_up = false
var interacting_player = null

func _ready():
	$ProgressBar.max_value = duration_of_interaction
	body_entered.connect(on_body_entered)
	body_exited.connect(on_body_exited)
	
func _process(delta):
	if picking_up:
		pickup_timer += delta
		$ProgressBar.value = pickup_timer
		if pickup_timer >= duration_of_interaction:
			successful_pickup.emit(interacting_player)
			stop_pickup()

func start_pickup():
	if interacting_player != null:
		picking_up = true
		pickup_timer = 0.0
	$ProgressBar.show()

func stop_pickup():
	picking_up = false
	$ProgressBar.hide()

func on_body_entered(body: Node2D):
	if body.is_in_group("player"):
		interacting_player = body

func on_body_exited(body: Node2D):
	if body.is_in_group("player"):
		interacting_player = null
		stop_pickup()

func _input(event):
	if event is InputEventKey:
		if event.is_action_pressed("pickup") and interacting_player != null:
			start_pickup()
		elif event.is_action_released("pickup"):
			stop_pickup()