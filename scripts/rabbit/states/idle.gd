extends State

@export var detect_range:float = 128

func on_enter(data_transfer = {}):
	pass
	
	
func on_exit():
	pass
	

func update(delta):
	master.move(Vector2.ZERO,delta)
	var nearest_entity = master.get_nearest_entity(detect_range)
	#print(nearest_entity)
	if master.hostile_nearby(detect_range):
		#If it detects a hostile entity (player or creature), chase (if state exists (predator-type)) or flee (prey-type)
		if master.state_machine.has_state(StateType.FLEE):
			master.form_mark(load("res://assets/UI/red_exclamation.png"))
			transitioned.emit(self,StateType.FLEE, {"target": nearest_entity})
