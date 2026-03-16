extends State

@export var detect_range:float = 164

var target:Entity

func on_enter(data_transfer = {}):
	target = data_transfer["target"]
	
	
func on_exit():
	pass
	

func update(delta):

	if target:
		var rela =  target.global_position - master.global_position
		var x_dire = sign(rela.x)
		
		
		if rela.length() > detect_range:
			transitioned.emit(self,StateType.IDLE)
		if rela.length() < 20:
			master.animation_player.play("eat")
		else:
			master.walk(Vector2(x_dire,0),delta)
		
		if master.current_hunger >= master.max_hunger or target.max_hunger <= 0:
			transitioned.emit(self,StateType.IDLE)
	else:
		transitioned.emit(self,StateType.IDLE)
