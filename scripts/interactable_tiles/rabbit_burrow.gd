extends InteractableObject
class_name RabbitBurrow

@export var other_burrow: RabbitBurrow

var burrow_active = true
@export var collision_shape: CollisionShape2D 


func _on_rabbit_enter(area: Area2D) -> void:
	if (area.get_parent() is Rabbit):
		if burrow_active:
			other_burrow.burrow_active = false
			(area.get_parent() as Node2D).global_position = other_burrow.global_position

func _on_rabbit_exit(area: Area2D) -> void:
	burrow_active = true

