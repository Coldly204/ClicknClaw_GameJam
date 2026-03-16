extends BaseIdleState


func update(delta):
	master.move(Vector2.ZERO,0,delta)
	var nearest_entity = master.get_nearest_entity(detect_range)
	var nearest_alpha = master.get_nearby(detect_range, "Wolf Alpha")
	var nearest_deadbody = master.get_nearest_corpse(detect_range)
	if nearest_entity:
		if master.is_hostile_to(nearest_entity.type):
			master.form_mark(load("res://assets/UI/white_exclamation.png"))
			transitioned.emit(self,StateType.CHASE, {"target": nearest_entity})
		if master.is_friendly_to(nearest_entity.type):
			if !(nearest_entity.type == Entity.EntityType.WOLF && (master as Wolf).is_alpha):
				transitioned.emit(self,StateType.FOLLOW, {"target": nearest_entity})
			else:
				roam(delta)
	elif nearest_deadbody:
		transitioned.emit(self,StateType.FORAGING, {"target": nearest_deadbody})
	else:
		roam(delta)
