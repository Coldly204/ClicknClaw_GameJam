extends Area2D
class_name Bush

func interact(player:Player):
	player.hiding = not player.hiding
	player.velocity = Vector2.ZERO
	player.global_position.x = global_position.x
