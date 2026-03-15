extends Sprite2D
class_name Disclaimer

var flow_vel:float = 1

var extra_pos:Vector2
var origin_pos:Vector2

func _ready() -> void:
	flow_vel = 1
	origin_pos = position

func _physics_process(delta: float) -> void:
	
	position.y -= flow_vel * delta * 80
	extra_pos.x = randf_range(-1,1) * flow_vel * 3
	position.x = origin_pos.x + extra_pos.x
	flow_vel -= delta * 2
	if flow_vel >= 0:
		modulate.a = 1-flow_vel
	else:
		modulate.a = 1 + flow_vel * 2
		
	if flow_vel <= -1:
		queue_free()
	
	
