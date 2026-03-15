extends CharacterBody2D
class_name Entity

@export_category("Attribute")
@export var max_health:int
@export var max_hunger:int
@export var walk_speed:float = 1.5
@export var run_speed_mult:float = 1.5
@export var type: EntityType

var hiding:bool = false

enum EntityType {
	PLAYER,
	RABBIT,
	WOLF,
}

@export_category("In-game Attribute")
@export var current_health:int
@export var current_hunger:int

func _ready() -> void:
	current_health = max_health
	add_to_group("Entity",true)

func get_nearest_entity(radius: float) -> Entity:
	var entities = get_tree().get_nodes_in_group("Entity")
	for entity: Entity in entities:
		if entity == self or entity.current_health <= 0 or entity.hiding:
			continue
		var dist_to_entity = entity.global_position.distance_to(global_position)
		if dist_to_entity <= radius:
			return entity
	return null



func get_nearest_deadbody(radius: float) -> Entity:
	var entities = get_tree().get_nodes_in_group("Entity") 
	for entity: Entity in entities:
		if entity == self or entity.current_health > 0:
			continue
		var dist_to_entity = entity.global_position.distance_to(global_position)
		if dist_to_entity <= radius:
			return entity
	return null

func is_player_near(dist:float):
	var player:Player = get_player()
	var distance = player.global_position.distance_to(global_position)
	return distance <= dist and not player.hiding

func get_player():
	var entities = get_tree().get_nodes_in_group("Entity")
	for i in entities:
		if i is Player:
			return i

func _physics_process(delta: float) -> void:
	other_process(delta)
	velocity.x *= 0.9
	velocity.y += delta * 960
	move_and_slide()

func other_process(delta:float):
	pass
