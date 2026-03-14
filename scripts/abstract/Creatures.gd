extends Entity
class_name Creature

@export_enum("Harmless","Hostile","Neutral") var hositility_type
@export_category("Components")
@export var appearance:Node2D
@export var collision:CollisionShape2D
@export var state_machine:StateMachine

@onready var shader_material = appearance.material

var shader_move_tick:float = 0



func move(motion:Vector2,_delta:float):
	velocity.x += motion.x * _delta * 420 * move_speed
	appearance.scale.x = sign(velocity.x) if velocity.x != 0 else appearance.scale.x
	shader_move_tick += (abs(motion.x)-shader_move_tick)*_delta*10
	if shader_material:
		shader_material.set_shader_parameter("move_tick", shader_move_tick)
		shader_material.set_shader_parameter("speed", move_speed * 3.0)
