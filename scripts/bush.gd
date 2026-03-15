extends InteractableObject
class_name Bush

func interact(player:Player):
	player.is_hiding = not player.is_hiding
	player.velocity = Vector2.ZERO
	player.global_position.x = global_position.x
