extends Creature
class_name Rabbit


func other_process(delta:float):
	super.other_process(delta)
	
func interact(player:Player):
	if current_health<=0:
		if player.held_item == "":
			player.held_item = "Meat"
		else:
			var new_meat:PickableItem = load("res://prefabs/interactables/grounded_item.tscn").instantiate()
			new_meat.item_name = "Meat"
			new_meat.global_position = global_position - Vector2(0,8)
			new_meat.set_texture(new_meat.item_texture[new_meat.item_name])
			Global.scene.add_child(new_meat)
			
		max_hunger -= 1
		if max_hunger <= 0:
			queue_free()
