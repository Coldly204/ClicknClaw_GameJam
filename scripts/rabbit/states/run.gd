extends State

@export var detect_range:float = 164

func on_enter(data_transfer = {}):
	pass
	
func on_exit():
	pass
	
func update(delta):
	var rela_player = master.get_player().global_position - master.global_position
	var x_dire = -sign(rela_player.x)
	master.move(Vector2(x_dire,0),delta)
	if not master.is_player_near(detect_range):
		transitioned.emit(self,"idle")
