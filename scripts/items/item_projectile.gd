extends CharacterBody2D
class_name ItemProjectile

var item_name:String
@export var sprite:Sprite2D

	
func _physics_process(delta: float) -> void:
	velocity.y += delta * 960
	var collide:bool = move_and_slide()
	
	if collide:
		var collider = get_last_slide_collision().get_collider()
		match item_name:
			"Stone":
				if not collider is Player:
					if collider is Creature :
						collider.current_health -= 1
					queue_free()
			"Meat":
				var new_meat:Item = load("res://prefabs/interactables/grounded_item.tscn").instantiate()
				new_meat.item_name = "Meat"
				new_meat.global_position = get_last_slide_collision().get_position() + Vector2(0,-8)
				new_meat.set_texture(new_meat.item_texture[new_meat.item_name])
				Global.scene.add_child(new_meat)
				queue_free()
		
