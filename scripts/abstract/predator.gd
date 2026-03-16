extends Creature
class_name Predator

@export var hitbox:Area2D

func other_process(delta:float):
	super.other_process(delta)

func attack():
	var hit_entities = hitbox.get_overlapping_bodies()
	for hit_entity in hit_entities:
		if hit_entity != self and hit_entity is Entity:
			(hit_entity as Entity).take_damage(1)

func eat():
	var hit_entity = hitbox.get_overlapping_bodies()
	for i:Entity in hit_entity:
		if i != self and i is Entity:
			if i.current_health <= 0 and i.max_hunger > 0:
				i.max_hunger -= 1
				current_hunger += 1
			
