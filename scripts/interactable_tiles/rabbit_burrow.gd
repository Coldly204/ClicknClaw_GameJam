extends InteractableObject
class_name RabbitBurrow

@export var other_burrow: RabbitBurrow

var burrow_active = true
@export var collision_shape: CollisionShape2D 


func _on_rabbit_enter(area: Area2D) -> void:
	if (area.get_parent() is Rabbit):
		if burrow_active:
			(area.get_parent() as Node2D).global_position = other_burrow.global_position
			other_burrow.burrow_active = false
			other_burrow.collision_shape.set_deferred("disabled",true)
			await get_tree().create_timer(1).timeout
			other_burrow.burrow_active = true
			other_burrow.collision_shape.set_deferred("disabled",false)

