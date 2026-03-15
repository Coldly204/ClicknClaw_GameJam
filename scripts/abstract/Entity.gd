extends CharacterBody2D
class_name Entity

enum EntityType {
	PLAYER,
	RABBIT,
	WOLF,
}

@export_category("Attributes")
@export var type: EntityType
@export var max_health: int
@export var max_hunger: int
@export var walk_speed: float = 1.5
@export var run_speed_multiplier: float = 1.5

@export_category("In-game Attribute")
@export var current_health: int
@export var current_hunger: int

var is_hiding: bool = false

func _ready() -> void:
	current_health = max_health
	add_to_group("Entity", true)

func get_nearby(radius: float, find_type: String = "Entity") -> Array[Node2D]:
	"""
	Return all nearby `find_type` (used as Group search string) at a `radius` distance away, sorted by proximity
	`find_type` should be "Entity" or "Corpse"
	"""
	var nearby_objects_array: Array[Node2D]
	var objects = get_tree().get_nodes_in_group(find_type)
	for object: Node2D in objects:
		if object == self:
			continue
		var dist_to_entity = object.global_position.distance_to(global_position)
		if dist_to_entity <= radius:
			nearby_objects_array.append(object)
	nearby_objects_array.sort_custom(func(a: Node2D, b: Node2D): return a.global_position.distance_to(global_position) < b.global_position.distance_to(global_position))
	return nearby_objects_array

func get_nearest_entity(radius: float) -> Entity:
	var entities = get_nearby(radius)
	if entities.size() > 0:
		return entities[0] as Entity
	return null

func get_nearest_corpse(radius: float) -> Corpse:
	var corpses = get_nearby(radius, "Corpse")
	if corpses.size() > 0:
		return corpses[0] as Corpse
	return null

func is_player_near(dist: float):
	var player: Player = get_player()
	var distance = player.global_position.distance_to(global_position)
	return distance <= dist and not player.is_hiding

func get_player():
	return get_tree().get_first_node_in_group("Player") as Player

func _physics_process(delta: float) -> void:
	other_process(delta)
	velocity.x *= 0.9
	velocity.y += delta * 960
	move_and_slide()

func other_process(delta: float):
	pass
