extends State









@export var detect_range:float = 128

func on_enter(data_transfer = {}):
	pass
	
	
func on_exit():
	pass
	

func update(delta):
	master.move(Vector2.ZERO,delta)
	var nearest_entity = master.get_nearest_entity(detect_range)
	var nearest_deadbody = master.get_nearest_deadbody(detect_range)

	if nearest_entity:
		transitioned.emit(self,StateType.CHASE, {"target": nearest_entity})
	elif nearest_deadbody:
		transitioned.emit(self,StateType.FORAGING, {"target": nearest_deadbody})
