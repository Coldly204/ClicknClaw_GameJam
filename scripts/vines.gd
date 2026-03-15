extends InteractObject
class_name Vines

var vines_list:Array

var next_pos:
	get():
		return vines_list[vines_list.find(self)+1].global_position
		
var vine_progress:
	get():
		return abs(float(map_pos.y-vines_list[0].map_pos.y) / float(vines_list[0].map_pos.y - vines_list[-1].map_pos.y))

func interact(player:Player):
	player.climbing = not player.climbing
	if player.climbing:
		player.climbing_progress = vine_progress
		player.climbing_vines = vines_list
	
