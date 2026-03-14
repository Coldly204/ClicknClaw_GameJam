extends Control

@export var player:Player
@export var hunger_list:HBoxContainer
@export var item_label:Label

func update_hunger():
	var children = hunger_list.get_children()
	if len(children) < player.max_hunger:
		for i in range(player.max_hunger - len(children)):
			var new_hunger = TextureRect.new()
			hunger_list.add_child(new_hunger)
	elif len(children) > player.max_hunger:
		for i in range(len(children)-player.max_hunger):
			children[-i-1].queue_free()
	
	children = hunger_list.get_children()
	for i in range(len(children)):
		var hunger:TextureRect = children[i]
		if hunger.is_inside_tree():
			if i <= player.current_hunger:
				hunger.texture = load("res://assets/UI/hunger_full.png")
			else:
				hunger.texture = load("res://assets/UI/hunger_empty.png")

func update_item():
	item_label.text = player.item
				
func _physics_process(delta: float) -> void:
	update_hunger()
	update_item()
