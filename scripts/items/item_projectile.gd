extends CharacterBody2D
class_name ItemProjectile

var item_name:String
var item: Item
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
					else:
						item.global_position = get_last_slide_collision().get_position() + Vector2(0,-8)
						Global.scene.add_child(item)
						queue_free()
			_:
				item.global_position = get_last_slide_collision().get_position() + Vector2(0,-8)
				Global.scene.add_child(item)
				queue_free()
		
