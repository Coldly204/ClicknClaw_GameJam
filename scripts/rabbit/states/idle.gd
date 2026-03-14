extends State

@export var detect_range:float = 128

func on_enter(data_transfer = {}):
	pass
	
	
func on_exit():
	pass
	

func update(delta):
	master.move(Vector2.ZERO,delta)
	if master.is_player_near(detect_range):
		transitioned.emit(self,"run")
