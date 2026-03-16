extends TileMapLayer


var vines = []


func _ready() -> void:
	form_interactable()


func form_interactable():
	for i in get_used_cells():
		var data = get_cell_tile_data(i)
		var texture:Texture2D = get_tile_texture(i)
		var pos = map_to_local(i)
		var new_object = data.get_custom_data("Replace").instantiate() as InteractableObject
		new_object.position = pos
		if !new_object.sprite:
			new_object.set_texture(texture)
		new_object.map_pos = i
		call_deferred("add_child",new_object)

		set_cell(i,-1)
		
		if new_object is Item:
			new_object.item_name = data.get_custom_data("ItemName")
		
		if new_object is Vines:
			if len(vines) == 0:
				var new_vines = [new_object]
				vines.push_back(new_vines)
				new_object.vines_list = new_vines
				
			else:
				var pushed = false
				for j in vines:
					var dires = [Vector2i(0,1),Vector2i(0,-1)]
					var connected = is_cell_connected(j,i,dires)
					if connected:
						j.push_back(new_object)
						new_object.vines_list = j
						pushed = true
						
				if not pushed:
					var new_vines = [new_object]
					vines.push_back(new_vines)
					new_object.vines_list = new_vines
					
	for i in vines:
		i.sort_custom(func(a,b): return a.map_pos.y > b.map_pos.y)
		
func is_cell_connected(cells:Array,pos:Vector2i,dires:Array):
	for i in cells:
		for j in dires:
			var dire_pos:Vector2i = pos + j
			if dire_pos == i.map_pos:
				return true
		
func get_tile_texture(cell_coords: Vector2i) -> Texture2D:
	var source_id: int = get_cell_source_id(cell_coords)
	var atlas_coords: Vector2i = get_cell_atlas_coords(cell_coords)
	#var alternative_tile: int = get_cell_alternative_tile(cell_coords)

	if source_id == -1 or atlas_coords == Vector2i(-1, -1):
		return null

	var source: TileSetSource = tile_set.get_source(source_id)
	if not (source is TileSetAtlasSource):
		return null

	var atlas_source: TileSetAtlasSource = source as TileSetAtlasSource
	var texture_region: Rect2i = atlas_source.get_tile_texture_region(atlas_coords)
	var atlas_texture: Texture2D = atlas_source.texture
	
	var image: Image = atlas_texture.get_image()
	var tile_image: Image = image.get_region(texture_region)
	var tile_texture: ImageTexture = ImageTexture.create_from_image(tile_image)

	return tile_texture
