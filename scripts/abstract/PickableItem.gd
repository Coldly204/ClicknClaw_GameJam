extends InteractObject
class_name PickableItem

var item_name:String = ""
@export var item_texture:Dictionary[String,Texture2D]

func interact(player:Player):
	if player.held_item == "":
		player.held_item = item_name
		queue_free()
	else:
		var temp = item_name
		item_name = player.held_item
		player.held_item = temp
		set_texture(item_texture[item_name])

func _physics_process(delta: float) -> void:
	pass
	
