extends InteractableObject
class_name Item

@export var projectile: PackedScene
@export var item_name: String

func interact(player:Player):
	if !player.held_item:
		print("loaded item")
		player.held_item = self.duplicate()
		player.held_item.projectile = projectile
		print(player.held_item.projectile)
		queue_free()
	else:
		var temp = player.held_item
		get_tree().root.add_child(temp)
		temp.global_position = player.global_position + Vector2.UP * 7
		player.held_item = self
		
		# item_name = player.held_item
