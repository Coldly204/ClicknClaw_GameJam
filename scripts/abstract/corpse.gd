extends InteractableObject
class_name Corpse

var food_amount:int
@export var food_item: PackedScene

func interact(player:Player):
	var new_meat:Item = food_item.instantiate()
	new_meat.global_position = player.global_position + Vector2.UP * 7
	Global.scene.add_child(new_meat)
	food_amount -= 1
	if food_amount <= 0:
		queue_free()
