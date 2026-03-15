extends InteractableObject
class_name Corpse

var food_amount:int

func interact(player:Player):
	if player.held_item == "":
		player.held_item = "Meat"
	else:
		var new_meat:PickableItem = load("res://prefabs/interactables/grounded_item.tscn").instantiate()
		
		new_meat.item_name = "Meat"
		new_meat.global_position = global_position - Vector2(0,8)
		new_meat.set_texture(new_meat.item_texture[new_meat.item_name])
		Global.scene.add_child(new_meat)
	food_amount -= 1
	if food_amount <= 0:
		queue_free()
