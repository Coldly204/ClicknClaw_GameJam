extends Entity
class_name Player

var shader_move_tick: float = 0

#Sujay: Potentially add a state-machine to player with climbing state? 
var climbing: bool = false
var climbing_vines: Array = []
var climbing_progress: float

@export var sprite: AnimatedSprite2D
@export var interaction_area: Area2D
@export var collision_shape: CollisionShape2D
@export var held_item: String = "Stone"
@export var dotted_line: Line2D

@onready var shader_material = sprite.material

var using_item: bool = false
var mouse_pos: Vector2
	
func _ready() -> void:
	add_to_group("Player",true)

func _physics_process(delta: float) -> void:
	motion_process(delta)
	
#Handles movement, climbing and throwing
func motion_process(delta: float):
	var input: Vector2 = Input.get_vector("left", "right", "up", "down")
	
	if Input.is_action_just_pressed("1"):
		Global.transition._dark()
	if Input.is_action_just_pressed("2"):
		Global.transition._light()
	
	
	
	if current_health <= 0:
		velocity.x = 0
		shader_move_tick = 0
		modulate = Color(1.0, 0.0, 0.0, 1.0)
		if max_hunger <= 0:
			queue_free()
	else:
		sprite.visible = true
		if climbing:
			var begin: Vector2 = climbing_vines[0].global_position
			var end: Vector2 = climbing_vines[-1].global_position
			climb(begin, end, input, delta)
		elif hiding:
			sprite.visible = false
		else:
			walk(input, delta)
			
			
			
		if held_item:
			if Input.is_action_just_pressed("eat"):
				if held_item == "Meat":
					current_hunger += 1
					held_item = ""

			elif Input.is_action_pressed("cancel_use"):
				dotted_line.visible = false
				using_item = false
			elif Input.is_action_pressed("use_item"):
				using_item = true
				if held_item == "Stone" or held_item == "Meat":
					dotted_line.visible = true
					mouse_pos = get_local_mouse_position()
					dotted_line.clear_points()
					var points = predict_trajectory(Vector2(0, -16), mouse_pos.normalized() * 480, 80, delta)
					for i in points:
						dotted_line.add_point(i)
			else:
				dotted_line.visible = false
				if using_item:
					throw(held_item)
					held_item = ""
					using_item = false
					
	if shader_material:
		shader_material.set_shader_parameter("move_tick", shader_move_tick)
		shader_material.set_shader_parameter("speed", move_speed * 3.0)
					
	move_and_slide()
	
func walk(input: Vector2, delta: float):
	sprite.animation = "default"
	collision_shape.disabled = false
	velocity.x += input.x * delta * 420 * move_speed
	velocity.x *= 0.9
	velocity.y += delta * 960
	sprite.scale.x = sign(velocity.x) if velocity.x != 0 else sprite.scale.x

	shader_move_tick += (abs(input.x) - shader_move_tick) * delta * 10

func climb(begin: Vector2, end: Vector2, input: Vector2, delta: float):
	global_position = begin.lerp(end, climbing_progress)
	climbing_progress = clamp(climbing_progress, 0, 1)
	collision_shape.disabled = true
	climbing_progress -= input.y * delta * 0.8
	sprite.animation = "climb"
	
	shader_move_tick += (abs(input.y) - shader_move_tick) * delta * 10

func throw(item: String):
	match (item):
		"Stone":
			var new_stone = load("res://prefabs/items/ThrowingItem.tscn").instantiate()
			new_stone.velocity = mouse_pos.normalized() * 480
			new_stone.item_name = "Stone"
			new_stone.global_position = global_position - Vector2(0, 16)
			Global.scene.add_child(new_stone)
		"Meat":
			var new_stone = load("res://prefabs/items/ThrowingItem.tscn").instantiate()
			new_stone.velocity = mouse_pos.normalized() * 480
			new_stone.item_name = "Meat"
			new_stone.global_position = global_position - Vector2(0, 16)
			Global.scene.add_child(new_stone)


func bezier(start: Vector2, end: Vector2, t: float):
	var direction = (end - start).normalized()
	var mid_point = (end + start) / 2
	
	mid_point.y -= 10000 / clamp(start.distance_to(end), 60, 99999)

	return (1 - t) ** 2 * start + 2 * (1 - t) * t * mid_point + (t ** 2) * end
	
func predict_trajectory(initial_pos: Vector2, initial_vel: Vector2, steps: int, step_time: float) -> PackedVector2Array:
	var points = PackedVector2Array()
	points.append(initial_pos) # 将起点加入数组

	var pos = initial_pos
	var vel = initial_vel

	for i in range(steps):
		vel.y += 960 * step_time
		# 更新位置
		var next_pos = pos + vel * step_time
		pos = next_pos

		
		var query: PhysicsPointQueryParameters2D = PhysicsPointQueryParameters2D.new()
		
		query.position = global_position + next_pos
		query.collision_mask = 1
		
		var results = get_world_2d().direct_space_state.intersect_point(query)
		points.append(next_pos)
		if results != []:
			break
	return points
	

		
