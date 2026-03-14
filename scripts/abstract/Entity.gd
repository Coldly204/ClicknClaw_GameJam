extends CharacterBody2D
class_name Entity

@export_category("Attribute")
@export var max_health:int
@export var max_hunger:int
@export var move_speed:float

@export_category("In-game Attribute")
@export var current_health:int
@export var current_hunger:int

func _ready() -> void:
	current_health = max_health
	add_to_group("Entity",true)

func get_predator(dist:float):
	var entities = get_tree().get_nodes_in_group("Entity")
	for i in entities:
		if i is Creature:
			if i.hositility_type == "Hostile":
				var distance = i.global_position.distance_to(global_position)
				if distance <= dist:
					return i
					
func is_player_near(dist:float):
	var player = get_player()
	var distance = player.global_position.distance_to(global_position)
	return distance <= dist

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
