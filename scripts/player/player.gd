extends Entity
class_name Player

var shader_move_tick: float = 0

#Sujay: Potentially add a state-machine to player with climbing state? 
var climbing: bool = false
var climb_start: Vector2
var climb_end: Vector2

@export var held_item: Item
@export var climb_speed = 10
@export var jump_height = 1

var grounded: bool

@export_category("Components")
@export var sprite: AnimatedSprite2D
@export var interaction_area: Area2D
@export var collision_shape: CollisionShape2D
@export var dotted_line: Line2D

@onready var shader_material = sprite.material

var using_item: bool = false
signal item_changed
var mouse_pos: Vector2
	
func _ready() -> void:
	climb_speed = 10
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
		return

	sprite.visible = true
	if climbing:
		climb(climb_start, climb_end, input, delta)
	elif is_hiding:
		sprite.visible = false
	else:
		walk(input, delta)
		
	if held_item:
		var held_item_name = held_item.item_name
		if Input.is_action_just_pressed("eat"):
			if held_item_name == "Meat":
				current_hunger += 1
				held_item = null
				item_changed.emit()
		elif Input.is_action_pressed("cancel_use"):
			dotted_line.visible = false
			using_item = false
		elif Input.is_action_pressed("use_item"):
			using_item = true
			if held_item_name == "Stone" or held_item_name == "Meat":
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
				held_item = null
				using_item = false
	if shader_material:
		shader_material.set_shader_parameter("move_tick", shader_move_tick)
		shader_material.set_shader_parameter("speed", base_walk_speed * 3.0)
					
	move_and_slide()
	grounded = is_on_floor()
	if Input.is_action_pressed("jump") and (grounded or climbing):
		jump()

	
func walk(input: Vector2, delta: float):
	sprite.animation = "default"
	collision_shape.disabled = false
	velocity.x += input.x * delta * 420 * base_walk_speed 
	velocity.x *= 0.9
	velocity.y += delta * 960
	sprite.scale.x = sign(velocity.x) if velocity.x != 0 else sprite.scale.x

	shader_move_tick += (abs(input.x) - shader_move_tick) * delta * 10

func climb(begin: Vector2, end: Vector2, input: Vector2, delta: float):
	# global_position = begin.lerp(end, climbing_progress)
	# climbing_progress = clamp(climbing_progress, 0, 1)
	collision_shape.disabled = true
	velocity.y = input.y * climb_speed
	velocity.y *= Global.TILEMAP_SIZE
	velocity.x = 0
	# global_position = clamp(global_position,begin,end)
	sprite.animation = "climb"
	global_position.y = clamp(global_position.y, end.y, begin.y)
	shader_move_tick += (abs(input.y) - shader_move_tick) * delta * 10

func jump():
	climbing = false
	velocity.y = -1 * jump_height * Global.TILEMAP_SIZE^2 


func hide_in_bush(tile_pos):
	is_hiding = not is_hiding
	velocity = Vector2.ZERO
	global_position.x = tile_pos.x

func choose_tile_interaction(action_name: StringName, tile_pos: Vector2, tile_map_layer: TileMapLayer):
	match action_name:
		"climb":
			climb_end = get_furthest_interactable_tile_position(tile_pos, Vector2i.UP,tile_map_layer) + Vector2.DOWN * Global.TILEMAP_SIZE
			climb_start = get_furthest_interactable_tile_position(tile_pos, Vector2i.DOWN,tile_map_layer)+ Vector2.UP * Global.TILEMAP_SIZE
			print("CLIMB START", climb_start)
			print("CLIMB END", climb_end)
			climbing = not climbing
			if (!climbing):
				jump()
		"hide":
			hide_in_bush(tile_pos)
		"pickup":
			var item = tile_map_layer.get_cell_tile_data(tile_map_layer.local_to_map(tile_pos)).get_custom_data("Player Item")
			tile_map_layer.set_cell(tile_map_layer.local_to_map(tile_pos))
			pickup_item(item.instantiate(), tile_map_layer.local_to_map(tile_pos))
			
			
func pickup_item(item, tilemap_coords):
	get_tree().root.add_child(item)
	item = item as Item
	item.interact(self)
	item_changed.emit()
			

func get_furthest_interactable_tile_position(start_tile_pos: Vector2i, direction: Vector2i, tile_map_layer: TileMapLayer):
	var offset := direction * Global.TILEMAP_SIZE
	var furthest_tile_pos: Vector2 = start_tile_pos
	var next_tile_up = tile_map_layer.local_to_map(start_tile_pos + offset)
	while tile_map_layer.get_cell_tile_data(next_tile_up) and tile_map_layer.get_cell_tile_data(next_tile_up).has_custom_data("Player Action"):
		next_tile_up += direction
	furthest_tile_pos = tile_map_layer.map_to_local(next_tile_up)
	return furthest_tile_pos 

func throw(item: Item):
	if !held_item:
		return
	var item_projectile = item.projectile.instantiate() as ItemProjectile
	item_projectile.velocity = mouse_pos.normalized() * 480
	item_projectile.item_name = item.item_name
	item_projectile.sprite.texture = item.sprite.texture
	item_projectile.item = held_item.duplicate()
	item_projectile.global_position = global_position - Vector2(0, 16)
	Global.scene.add_child(item_projectile)
	held_item = null
	item_changed.emit()
	return

	

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
	

		
