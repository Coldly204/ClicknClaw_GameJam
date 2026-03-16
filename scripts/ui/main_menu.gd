extends Control

@onready var start_button = $VBoxContainer/Start

func _ready():
	start_button.pressed.connect(_on_start_pressed)

func _on_start_pressed():
	get_tree().change_scene_to_file("res://scenes/game.tscn")
