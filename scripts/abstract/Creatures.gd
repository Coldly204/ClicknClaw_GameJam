extends Entity
class_name Creature

@export var _current_relationships: Dictionary[EntityType, RelationshipType]
@export var _current_enmity_values: Dictionary[EntityType, float]

enum RelationshipType {
	HOSTILE,
	NEUTRAL,
	FRIENDLY
}

@export var texture_corpse:Texture2D

@export_category("Relationships")
#If the enmity of another entity increases past this, this entity is hostile to it
var threshold_till_hostile = 0.8
#Default enmity value, if unspecified
var base_enmity = 0.5
#If the enmity of another entity goes below this, this entity is friendly to it
var threshold_till_friendly = 0.3
@export var default_enmity_values: Dictionary[EntityType, float]

@export_category("Components")
@export var appearance:Node2D
@export var collision:CollisionShape2D
@export var interaction_area:Area2D
@export var state_machine:StateMachine
@export var animation_player:AnimationPlayer

@onready var shader_material = appearance.material

var shader_move_tick:float = 0
@export var extra_rot:float = 0

func _ready() -> void:
	super._ready()
	_current_enmity_values = default_enmity_values.duplicate()
	for entity_type in EntityType.values():
		if !_current_enmity_values.has(entity_type):
			_current_enmity_values[entity_type] = base_enmity
	for entity_type in _current_enmity_values.keys():
		_current_relationships[entity_type] = RelationshipType.NEUTRAL
		update_relationship_with(entity_type)

func move(motion:Vector2,move_speed: float,_delta:float):
	velocity.x += sign(motion.x) * _delta * 420 * move_speed 
	appearance.scale.x = sign(velocity.x) if velocity.x != 0 else appearance.scale.x
	shader_move_tick += (abs(motion.x)-shader_move_tick)*_delta*10
	if shader_material:
		shader_material.set_shader_parameter("move_tick", shader_move_tick)
		shader_material.set_shader_parameter("speed", walk_speed * 3.0)


func walk(motion: Vector2, _delta: float):
	move(motion,walk_speed,_delta)

func run(motion: Vector2, _delta: float):
	move(motion,walk_speed * run_speed_mult,_delta)


func set_enmity(creature_type: EntityType, new_enmity: float):
	_current_enmity_values[creature_type] = clampf(new_enmity,0,1)
	update_relationship_with(creature_type)

func update_relationship_with(creature_type: EntityType):
	var enmity = _current_enmity_values[creature_type]
	if enmity >= threshold_till_hostile:
		_current_relationships[creature_type] = RelationshipType.HOSTILE
	elif enmity <= threshold_till_friendly:
		_current_relationships[creature_type] = RelationshipType.FRIENDLY
	else:
		_current_relationships[creature_type] = RelationshipType.NEUTRAL

func get_relationship_with(creature_type: EntityType):
	return _current_relationships[creature_type]


func hostile_nearby(detect_range: float) -> bool:
	var nearest_entity = get_nearest_entity(detect_range)
	if nearest_entity:
		if is_hostile_to(nearest_entity.type):
			return true
	return false


func is_hostile_to(creature_type: EntityType) -> bool:
	return _current_relationships[creature_type] == RelationshipType.HOSTILE

func is_friendly_to(creature_type: EntityType) -> bool:
	return _current_relationships[creature_type] == RelationshipType.FRIENDLY

func is_neutral_to(creature_type: EntityType) -> bool:
	return _current_relationships[creature_type] == RelationshipType.NEUTRAL

func form_mark(texture:Texture2D):
	var new_disclaimer = load("res://prefabs/Mark.tscn").instantiate()
	new_disclaimer.position = Vector2(0,-16)
	new_disclaimer.texture = texture
	add_child(new_disclaimer)

func get_nearest_hostile(radius: float) -> Entity:
	var entities = get_tree().get_nodes_in_group("Entity")
	for entity: Entity in entities:
		if entity == self or entity.current_health <= 0 or entity.hiding:
			continue
		var dist_to_entity = entity.global_position.distance_to(global_position)
		if dist_to_entity <= radius and is_hostile_to(entity.type):
			return entity
	return null
	
func other_process(delta:float):
	
	shader_material.set_shader_parameter("extra_rot", extra_rot)
	
	if current_health <= 0:
		death()
		queue_free()
	else:
		state_machine.update(delta)

func death():
	var new_corpse:Corpse = load("res://prefabs/entities/corpse.tscn").instantiate()
	new_corpse.global_position = global_position + Vector2(0,-8)
	new_corpse.food_amount = max_hunger
	new_corpse.set_texture(texture_corpse)
	Global.scene.add_child(new_corpse)
