extends State

@export var detect_range:float = 164
var target: Entity

func on_enter(data_transfer = {}):
	target = data_transfer["target"] 
	pass
	
func on_exit():
	pass
	
func update(delta):
	var target_relative_vector =  target.global_position - master.global_position
	var x_dire = -sign(target_relative_vector.x)
	master.run(Vector2(x_dire,0),delta)
	if target_relative_vector.length() > detect_range:
		transitioned.emit(self,StateType.IDLE)


