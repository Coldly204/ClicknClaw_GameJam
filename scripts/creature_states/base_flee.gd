extends State
class_name BaseFleeState

@export var detect_range:float = 200
var target: Entity

func on_enter(data_transfer = {}):
	target = data_transfer["target"] 
	pass
	
func on_exit():
	pass
	
func update(delta):
	var flee_dir =  -sign(target.global_position.x - master.global_position.x)
	master.nav_agent.target_position = master.global_position + Vector2.RIGHT * flee_dir * detect_range
	var vector := master.global_position.direction_to(master.nav_agent.get_next_path_position())
	master.run(vector,delta)
	if master.global_position.distance_to(target.global_position) > detect_range:
		transitioned.emit(self,StateType.IDLE)
