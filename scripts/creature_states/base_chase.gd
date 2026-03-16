extends State
class_name BaseChaseState

@export var detect_range:float = 164

var target:Entity

func on_enter(data_transfer = {}):
	target = data_transfer["target"]
	
	
func on_exit():
	pass
	
func update(delta):
	if target and target.current_health > 0:
		master.nav_agent.target_position = target.global_position
		var vector := master.global_position.direction_to(master.nav_agent.get_next_path_position())
		var distance_to_target = master.global_position.distance_to(target.global_position)
		if distance_to_target > detect_range or target.is_hiding:
			transitioned.emit(self,StateType.IDLE)
		if distance_to_target < 20:
			master.animation_player.play("attack")
		else:
			if master.nav_agent.is_target_reachable() and !master.nav_agent.is_target_reached():
				master.run(vector,delta)
	else:
		transitioned.emit(self,StateType.IDLE)
