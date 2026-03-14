extends Entity
class_name Player


var shader_move_tick:float = 0

var climbing:bool = false
var climbing_vines:Array = []
var climbing_progress:float

@export var sprite:AnimatedSprite2D
@export var interaction : Area2D
@export var collision_shape:CollisionShape2D

@onready var shader_material = sprite.material

func _ready() -> void:
	pass
	

func _physics_process(delta: float) -> void:
	motion_process(delta)
	
	



func motion_process(_delta:float):
	var motion : Vector2 = Input.get_vector("left","right","up","down")
	if climbing:
		var begin:Vector2 = climbing_vines[0].global_position
		var end:Vector2 = climbing_vines[-1].global_position
		global_position = begin.lerp(end,climbing_progress)
		climbing_progress = clamp(climbing_progress,0,1)
		collision_shape.disabled = true
		climbing_progress -= motion.y * _delta * 0.8
		sprite.animation = "climb"
		
		shader_move_tick += (abs(motion.y)-shader_move_tick)*_delta*10
		
	else:
		sprite.animation = "default"
		collision_shape.disabled = false
		velocity.x += motion.x * _delta * 420 * move_speed
		velocity.x *= 0.9
		velocity.y += _delta * 960
		sprite.scale.x = sign(velocity.x) if velocity.x != 0 else sprite.scale.x

		shader_move_tick += (abs(motion.x)-shader_move_tick)*_delta*10


	if shader_material:
		shader_material.set_shader_parameter("move_tick", shader_move_tick)
		shader_material.set_shader_parameter("speed", move_speed * 3.0)
		
	move_and_slide()
