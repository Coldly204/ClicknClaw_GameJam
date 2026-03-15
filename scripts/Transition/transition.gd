extends ColorRect
class_name TransitionScreen

var target_height = -1
var height = -1

func _ready() -> void:
	Global.transition = self

func _dark():
	target_height = 1
	
func _light():
	target_height = -1.5
	
	
func _physics_process(delta: float) -> void:
	height += (target_height - height) * delta * 2
	material.set_shader_parameter("height", height)
	
	
