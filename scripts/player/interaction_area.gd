extends Area2D
class_name InteractionArea

@export var master:Player
@export var interaction_sprite: TextureRect

func _physics_process(delta: float) -> void:
	var interactable_objects = get_overlapping_areas()
	var interactable_bodies = get_overlapping_bodies()
	var interactable_tile_map_layer: TileMapLayer
	var nearest_interactable_object: InteractableObject
	interaction_sprite.visible = false
	if interactable_objects:
		interaction_sprite.visible = true
		interactable_objects.sort_custom(func(a,b): return a.global_position.distance_to(global_position) < b.global_position.distance_to(global_position))
		nearest_interactable_object = interactable_objects[0]
	if interactable_bodies:
		interaction_sprite.visible = true
		interactable_tile_map_layer = interactable_bodies[0] as TileMapLayer if interactable_bodies[0] is TileMapLayer else null
	if Input.is_action_just_pressed("interact"):
		if nearest_interactable_object:
			nearest_interactable_object.interact(master)
		elif interactable_tile_map_layer:
			var nearby_tiles: Array
			var player_action: String
			for cell in interactable_tile_map_layer.get_used_cells():
				var cell_pos = interactable_tile_map_layer.map_to_local(cell)
				if Geometry2D.is_point_in_circle(cell_pos,master.global_position,20):
					if interactable_tile_map_layer.get_cell_tile_data(cell).has_custom_data("Player Action"):
						nearby_tiles.append(cell_pos)
						player_action = interactable_tile_map_layer.get_cell_tile_data(cell).get_custom_data("Player Action")
			nearby_tiles.sort_custom(func(a,b): return a.distance_to(master.global_position) < b.distance_to(master.global_position))
			if nearby_tiles:
				var nearest_tile_pos: Vector2 = nearby_tiles[0]
				master.choose_tile_interaction(
					player_action,
					nearest_tile_pos,
					interactable_tile_map_layer
					)
