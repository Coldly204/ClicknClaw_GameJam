extends CharacterBody2D


func _physics_process(delta: float) -> void:
	velocity.y += delta * 960
	var collide:bool = move_and_slide()
	if collide:
		var collider = get_last_slide_collision().get_collider()
		if collider is Entity:
			collider.current_health -= 1
		queue_free()
