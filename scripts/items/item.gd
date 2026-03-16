extends InteractableObject
class_name Item

@export var projectile: PackedScene
@export var item_name: String

func interact(player:Player):
	if !player.held_item:
		player.held_item = self.duplicate()
		player.held_item.projectile = projectile
	else:
		var temp = player.held_item
		get_tree().root.add_child(temp)
		temp.global_position = player.global_position + Vector2.UP * 7
		player.held_item = self.duplicate()
	player.item_changed.emit()
	queue_free()
		# item_name = player.held_item
