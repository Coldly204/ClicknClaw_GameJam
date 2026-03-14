extends Entity
class_name Player


var shader_move_tick:float = 0

@export var sprite:Sprite2D

@onready var shader_material = sprite.material

func _ready() -> void:
	pass
	

func _physics_process(delta: float) -> void:
	motion_process(delta)
	
	



func motion_process(_delta:float):
	var motion : Vector2 = Input.get_vector("left","right","up","down")
	velocity.x += motion.x * _delta * 840 * move_speed
	velocity.x *= 0.9

	shader_move_tick += (abs(motion.x)-shader_move_tick)*_delta*10


	
	if shader_material:
		shader_material.set_shader_parameter("move_tick", shader_move_tick)
		shader_material.set_shader_parameter("speed", move_speed * 3.0)

	velocity.y += _delta * 960
	move_and_slide()
