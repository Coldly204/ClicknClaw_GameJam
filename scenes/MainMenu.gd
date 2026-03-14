extends Control

@onready var start_button = $VBoxContainer/Start
@onready var guide_button = $VBoxContainer/Guide
@onready var exit_button = $VBoxContainer/Exit

func _ready():
	start_button.pressed.connect(_on_start_pressed)
	guide_button.pressed.connect(_on_guide_pressed)
	exit_button.pressed.connect(_on_exit_pressed)

func _on_start_pressed():
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_guide_pressed():
	print("How to play clicked")

func _on_exit_pressed():
	get_tree().quit()
