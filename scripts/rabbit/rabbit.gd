extends Creature
class_name Rabbit



func other_process(delta:float):
	state_machine.update(delta)
	if current_health <= 0:
		queue_free()
	
