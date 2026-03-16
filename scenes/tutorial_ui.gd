extends CanvasLayer

@onready var panel_throw: Panel = $Panel
@onready var throw_icon: TextureRect = $Panel/throw_rock
@onready var mouse_left_icon: TextureRect = $Panel/mouse_left

@onready var panel_cancel: Panel = $Panel2
@onready var cancel_icon: TextureRect = $Panel2/cancel_throw
@onready var mouse_right_icon: TextureRect = $Panel2/mouse_right

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_player2: AnimationPlayer = $AnimationPlayer2
@onready var timer: Timer = $Timer
@onready var timer2: Timer = $Timer2

var shown_tutorials := {}

func _ready() -> void:
	add_to_group("tutorial_ui")

	panel_throw.visible = false
	panel_throw.modulate.a = 0.0

	panel_cancel.visible = false
	panel_cancel.modulate.a = 0.0

	timer.one_shot = true
	timer2.one_shot = true

	timer.timeout.connect(_on_throw_timer_timeout)
	timer2.timeout.connect(_on_cancel_timer_timeout)


	await get_tree().create_timer(1.0).timeout
	await show_throw_tutorial(2.0)

	await get_tree().create_timer(1.0).timeout
	await show_cancel_tutorial(2.0)


func show_throw_tutorial(duration: float = 2.0) -> void:
	if shown_tutorials.has("throw"):
		return

	shown_tutorials["throw"] = true
	panel_throw.visible = true
	animation_player.play("fade_in")
	timer.start(duration)

	await timer.timeout
	await get_tree().create_timer(1.0).timeout


func show_cancel_tutorial(duration: float = 2.0) -> void:
	if shown_tutorials.has("cancel"):
		return

	shown_tutorials["cancel"] = true
	panel_cancel.visible = true
	animation_player2.play("fade_in")
	timer2.start(duration)

	await timer2.timeout
	await get_tree().create_timer(1.0).timeout


func _on_throw_timer_timeout() -> void:
	animation_player.play("fade_out")
	await get_tree().create_timer(1.0).timeout
	panel_throw.visible = false
	panel_throw.modulate.a = 0.0


func _on_cancel_timer_timeout() -> void:
	animation_player2.play("fade_out")
	await get_tree().create_timer(1.0).timeout
	panel_cancel.visible = false
	panel_cancel.modulate.a = 0.0
