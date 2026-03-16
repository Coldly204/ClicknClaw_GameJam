extends Sprite2D
class_name CreatureMark

var flow_vel:float = 1

var extra_pos:Vector2
var origin_pos:Vector2

var lifetime_timer: SceneTreeTimer

@export var duration: float = 0.2

func _ready() -> void:
	flow_vel = 1
	origin_pos = position
	lifetime_timer = get_tree().create_timer(duration)
	lifetime_timer.timeout.connect(func(): queue_free())

func _physics_process(delta: float) -> void:
	flow_vel = lifetime_timer.time_left
	position.y -= flow_vel * delta * 100
	extra_pos.x = randf_range(-1,1) * flow_vel * 5
	position.x = origin_pos.x + extra_pos.x
	if flow_vel >= 0:
		modulate.a = 1-flow_vel
	else:
		modulate.a = 1 + flow_vel * 2
	
