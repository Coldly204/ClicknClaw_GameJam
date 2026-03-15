extends State

@export var detect_range:float = 164

var target:Entity

func on_enter(data_transfer = {}):
	target = data_transfer["target"]
	
	
func on_exit():
	pass
	

func update(delta):
	if target and target.current_health > 0:
		var rela =  target.global_position - master.global_position
		var x_dire = sign(rela.x)
		
		
		if rela.length() > detect_range or target.hiding:
			transitioned.emit(self,StateType.IDLE)
		if rela.length() < 20:
			master.animation_player.play("attack")
		else:
			master.move(Vector2(x_dire,0),delta)
	else:
		transitioned.emit(self,StateType.IDLE)
