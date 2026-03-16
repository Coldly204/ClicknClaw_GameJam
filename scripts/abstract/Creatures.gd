extends Entity
class_name Creature

@export var _current_relationships: Dictionary[EntityType, RelationshipType]
@export var _current_enmity_values: Dictionary[EntityType, float]

enum RelationshipType {
	HOSTILE,
	NEUTRAL,
	FRIENDLY
}

@export var corpse_texture:Texture2D

@export_category("Relationships")
#Default enmity value, if unspecified
@export var base_relationship: RelationshipType = RelationshipType.NEUTRAL
#If the enmity of another entity increases past this, this entity is hostile to it
var _threshold_till_hostile = 0.8
#If the enmity of another entity goes below this, this entity is friendly to it
var _threshold_till_friendly = 0.3
var _neutral_enmity_value
@export var default_relationships: Dictionary[EntityType, RelationshipType]

@export_category("Components")
@export var appearance:Node2D
@export var collider:CollisionShape2D
@export var interaction_area:Area2D
@export var state_machine:StateMachine
@export var animation_player:AnimationPlayer
@export var nav_agent: NavigationAgent2D

@onready var shader_material = appearance.material

var shader_move_tick:float = 0
@export var extra_rotation:float = 0

func _ready() -> void:
	super._ready()
	intialise_relationships(default_relationships)


func intialise_relationships(relationship_dict: Dictionary[Entity.EntityType, RelationshipType]):
	"""
	Updates all enmity values and relationships based on `relationship_dict`. Also sets relationships
	with all other creature types (except its own type) to `base_relationship` (usually NEUTRAL)
	"""
	_neutral_enmity_value = (_threshold_till_hostile - _threshold_till_friendly)/2
	_current_relationships = relationship_dict.duplicate()
	for entity_type in EntityType.values():
		if !_current_relationships.has(entity_type):
			if entity_type == self.type:
				_current_relationships[entity_type] = RelationshipType.NEUTRAL
			else:
				_current_relationships[entity_type] = base_relationship
	for entity_type in _current_relationships.keys():
		update_enmity_value(entity_type)
		

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
	move(motion,walk_speed * run_speed_multiplier,_delta)


func set_enmity(creature_type: EntityType, new_enmity: float):
	_current_enmity_values[creature_type] = clampf(new_enmity,0,1)
	update_relationship_with(creature_type)

func update_relationship_with(creature_type: EntityType):
	var enmity = _current_enmity_values[creature_type]
	if enmity >= _threshold_till_hostile:
		_current_relationships[creature_type] = RelationshipType.HOSTILE
	elif enmity <= _threshold_till_friendly:
		_current_relationships[creature_type] = RelationshipType.FRIENDLY
	else:
		_current_relationships[creature_type] = RelationshipType.NEUTRAL

func update_enmity_value(creature_type: EntityType):
	var relationship = _current_relationships[creature_type]
	match relationship:
		RelationshipType.HOSTILE:
			_current_enmity_values[creature_type] = _threshold_till_hostile
		RelationshipType.NEUTRAL:
			_current_enmity_values[creature_type] = _neutral_enmity_value
		RelationshipType.FRIENDLY:
			_current_enmity_values[creature_type] = _threshold_till_friendly

func get_relationship_with(creature_type: EntityType):
	return _current_relationships[creature_type]

func get_enmity_value_regarding(creature_type: EntityType):
	return _current_enmity_values[creature_type]


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
	var entities = get_nearby(radius)
	if entities.size() == 0:
		return null
	var hostiles = entities.filter(func(entity: Entity): return is_hostile_to(entity.type))
	if hostiles:
		return hostiles[0]
	return null
	
func other_process(delta:float):
	shader_material.set_shader_parameter("extra_rotation", extra_rotation)
	if current_health <= 0:
		die()
		queue_free()
	else:
		state_machine.update(delta)

func die():
	var new_corpse:Corpse = load("res://prefabs/entities/corpse.tscn").instantiate()
	new_corpse.global_position = global_position + Vector2(0,-8)
	new_corpse.food_amount = max_hunger
	new_corpse.set_texture(corpse_texture)
	Global.scene.add_child(new_corpse)
