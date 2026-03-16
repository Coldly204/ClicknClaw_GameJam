extends Area2D
class_name InteractionArea

@export var master:Player
@export var label:Label

func _physics_process(delta: float) -> void:
	var areas = get_overlapping_areas()
	if areas:
		label.visible = true
		areas.sort_custom(func(a,b): return a.global_position.distance_to(global_position) < b.global_position.distance_to(global_position))
		var interactable = areas[0]
		if Input.is_action_just_pressed("interact"):
			interactable.interact(master)
	else:
		label.visible = false
