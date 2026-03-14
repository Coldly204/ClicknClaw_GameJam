extends Node
class_name StateMachine

@export var init_state:State.StateType

@export var master:Creature

var current_state:State 
var states:Dictionary[State.StateType,State] = {}

func _ready() -> void:
	for i in get_children():
		if i is State:
			i.transitioned.connect(_on_state_transition)
			i.master = master
			# if !i.StateType.get(i.name.to_upper()):
				# push_error("An invalid state name has been added to %s! %s is not a StateType!" % [master.name, i.name.to_upper()])
			i.type = State.StateType.get(i.name.to_upper())
			states[i.type] = i
			if i.type == init_state:
				i.on_enter()
				current_state = i
	
func has_state(state_type: State.StateType):
	return states.has(state_type)

func update(delta):
	if current_state != null:
		current_state.update(delta)
		
func _on_state_transition(c_state,new_state: State.StateType ,data_transfer = {}):
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
