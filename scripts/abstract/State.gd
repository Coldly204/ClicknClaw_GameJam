extends Node
class_name State

var master:Creature
var type: StateType

enum StateType {
	IDLE,
	FLEE,
	CHASE,
	HIDE,
	FORAGING,
}

signal transitioned



func on_enter(data_transfer = {}):
	pass

func on_exit():
	pass
	
func update(delta):
	master.move(Vector2.ZERO,delta)
	
