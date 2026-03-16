extends BaseFleeState

var burrows: Array[Node2D]
var nearest_burrow: RabbitBurrow

func update(delta):
	var flee_dir =  -sign(target.global_position.x - master.global_position.x)
	var dist_to_target = master.global_position.distance_to(target.global_position)
	burrows = master.get_nearby(detect_range,"Rabbit Burrow")
	if master.global_position.distance_to(target.global_position) > detect_range:
		master.nav_agent.target_position = master.global_position
		transitioned.emit(self,StateType.IDLE)
	if burrows:
		nearest_burrow = burrows[0] as RabbitBurrow
		var dist_to_burrow = master.global_position.distance_to(nearest_burrow.global_position)
		if nearest_burrow.burrow_active:
			if (dist_to_burrow < dist_to_target):
				master.nav_agent.target_position = nearest_burrow.global_position
	else:
		master.nav_agent.target_position = master.global_position + Vector2.RIGHT * flee_dir * detect_range
	var vector := master.global_position.direction_to(master.nav_agent.get_next_path_position())
	master.run(vector,delta)
