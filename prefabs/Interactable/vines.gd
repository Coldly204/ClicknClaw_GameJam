extends Area2D
class_name Vines


@export var sprite:Sprite2D

var map_pos:Vector2i
var vines_list:Array

var next_pos:
	get():
		return vines_list[vines_list.find(self)+1].global_position
		
var vine_progress:
	get():
		return map_pos.y/(vines_list[0].map_pos.y - vines_list[-1].map_pos.y)

func set_texture(texture:Texture2D):
	sprite.texture = texture

func interact(player:Player):
	player.climbing = not player.climbing
	if player.climbing:
		player.climbing_progress = vine_progress
		player.climbing_vines = vines_list
