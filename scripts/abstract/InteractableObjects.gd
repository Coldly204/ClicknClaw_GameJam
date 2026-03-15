extends Area2D
class_name InteractObject

@export var sprite:Sprite2D
var map_pos:Vector2i

func set_texture(texture:Texture2D):
	sprite.texture = texture
	
func interact(player:Player):
	pass
