extends Node
class_name StateMachine

@export var init_state:State

@export var master:Entity

var current_state:State 
var states:Dictionary = {}

func _ready() -> void:
	for i in get_children():
		if i is State:
			i.transitioned.connect(_on_state_transition)
			states[i.name] = i
			i.master = master
			if i == init_state:
				init_state.on_enter()
				current_state = init_state
	


func update(delta):
	if current_state != null:
		current_state.update(delta)
		
func _on_state_transition(c_state,new_state,data_transfer = {}):
	#print(new_state)
	if c_state == current_state:
		var update_state = states.get(new_state) #获取下一个状态
		if update_state == null:
			return
		elif current_state != null:
			current_state.on_exit()
		update_state.on_enter(data_transfer)
		current_state = update_state
	else:
		return

func force_transition(new_state,data_transfer = {}):
	var update_state = states.get(new_state)
	if update_state == null:
		return
	elif current_state != null:
		current_state.on_exit()
	update_state.on_enter(data_transfer)
	current_state = update_state
