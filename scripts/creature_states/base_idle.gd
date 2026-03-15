extends State

@export var detect_range:float = 128

func on_enter(data_transfer = {}):
	pass
		
func on_exit():
	pass

func update(delta):
	master.move(Vector2.ZERO,0,delta)
	var nearest_hostile = master.get_nearest_hostile(detect_range)
	if nearest_hostile:
		#If it detects a hostile entity (player or creature), chase (if state exists (predator-type)) or flee (prey-type)
		if master.state_machine.has_state(StateType.CHASE):
			transitioned.emit(self,StateType.CHASE, {"target": nearest_hostile})
		elif master.state_machine.has_state(StateType.FLEE):
			master.form_mark(load("res://assets/UI/red_exclamation.png"))
			transitioned.emit(self,StateType.FLEE, {"target": nearest_hostile})
