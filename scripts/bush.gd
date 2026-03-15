extends Area2D
class_name Bush

@export var sprite:Sprite2D

var map_pos:Vector2i

func set_texture(texture:Texture2D):
	sprite.texture = texture
func interact(player:Player):
	player.hiding = not player.hiding
	player.velocity = Vector2.ZERO
	player.global_position.x = global_position.x
