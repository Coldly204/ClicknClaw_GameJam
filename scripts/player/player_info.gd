extends Control

@export var player: Player
@export var health_list: HBoxContainer
@export var hunger_list: HBoxContainer
@export var item_label: Label
@export var time_icon: TextureRect

var heart_full = preload("res://sprites/UI/heart_full.png.png")
var heart_empty = preload("res://sprites/UI/heart_empty.png")
var hunger_full = preload("res://sprites/UI/hunger_full.png")
var hunger_empty = preload("res://sprites/UI/hunger_empty.png")

var day_texture = preload("res://sprites/UI/day.png")
var night_texture = preload("res://sprites/UI/night.png")

var time_counter = 0.0

func update_health():
	var children = health_list.get_children()

	if len(children) < player.max_health:
		for i in range(player.max_health - len(children)):
			var new_heart = TextureRect.new()
			new_heart.custom_minimum_size = Vector2(32, 32)
			new_heart.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
			health_list.add_child(new_heart)
	elif len(children) > player.max_health:
		for i in range(len(children) - player.max_health):
			children[-i - 1].queue_free()

	children = health_list.get_children()

	for i in range(len(children)):
		var heart: TextureRect = children[i]
		if heart.is_inside_tree():
			if i < player.current_health:
				heart.texture = heart_full
			else:
				heart.texture = heart_empty

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
	if player.held_item:
		item_label.text = player.held_item.item_name
	else:
		item_label.text = ""
	
func update_time_ui():
	if time_icon == null:
		return

	if !Global.is_night:
		time_icon.texture = day_texture
	else:
		time_icon.texture = night_texture

func _ready():
	player.item_changed.connect(update_item)
	update_time_ui()

func _physics_process(delta: float) -> void:
	update_health()
	update_hunger()