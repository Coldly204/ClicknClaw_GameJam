extends State
class_name BaseIdleState

@export var detect_range:float = 128

var roam_timer: Timer
@export var roam_time: float = 5

func on_enter(data_transfer = {}):
	roam_timer.start()
	pass
		
func on_exit():
	pass

func _ready() -> void:
	roam_timer = get_child(0)
	roam_timer.wait_time = roam_time
	roam_timer.timeout.connect(change_roam_location)

func update(delta):
	master.move(Vector2.ZERO,0,delta)
	var nearest_hostile = master.get_nearest_hostile(detect_range)
	if nearest_hostile:
		#If it detects a hostile entity (player or creature), chase (if state exists (predator-type)) or flee (prey-type)
		if master.state_machine.has_state(StateType.CHASE):
			transitioned.emit(self,StateType.CHASE, {"target": nearest_hostile})
		elif master.state_machine.has_state(StateType.FLEE):
			master.form_mark(load("res://assets/UI/red_exclamation.png"))
			transitioned.emit(self,StateType.FLEE, {"target": nearest_hostile})
	else:
		roam(delta)


func change_roam_location():
	master.nav_agent.target_position = master.global_position +  Global.TILEMAP_SIZE * 8 * Vector2.RIGHT * randi_range(-1,1) + Vector2.UP * Global.TILEMAP_SIZE

func roam(delta):
	if !master.nav_agent.is_target_reached():
		var walk_dir := master.global_position.direction_to(master.nav_agent.get_next_path_position())
		master.walk(walk_dir,delta)
