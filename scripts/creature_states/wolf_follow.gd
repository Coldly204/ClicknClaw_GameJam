extends State

@export var follow_range:float = 400
#Will not be more than this close to other friendlies
@export var follow_threshold:float = 50

var target:Entity

func on_enter(data_transfer = {}):
	target = data_transfer["target"]
	
func on_exit():
	pass
	

func update(delta):
	if target and target.current_health > 0:
		var rela =  target.global_position - master.global_position
		var x_dire = sign(rela.x)
		if rela.length() >= follow_range or rela.length() <= follow_threshold:
			transitioned.emit(self,StateType.IDLE)
		else:
			master.walk(Vector2(x_dire,0),delta)
	else:
		transitioned.emit(self,StateType.IDLE)
