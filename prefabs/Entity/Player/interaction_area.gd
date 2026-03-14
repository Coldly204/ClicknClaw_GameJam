extends Area2D
class_name InteractionArea

@export var master:Player

func _physics_process(delta: float) -> void:
	var areas = get_overlapping_areas()
	if areas:
		areas.sort_custom(func(a,b): return a.global_position.distance_to(global_position) < b.global_position.distance_to(global_position))
		var interact_on = areas[0]
		if Input.is_action_just_pressed("interact"):
			interact_on.interact(master)
