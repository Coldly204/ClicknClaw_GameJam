extends Node

@export var timer: Timer
@export var night_light: DirectionalLight2D

@export var sunset_duration: float = Global.SUNSET_DURATION_SECS

signal changing_time_period

func _ready() -> void:
	timer.wait_time = Global.DAY_DURATION_SECS
	timer.start()
	timer.timeout.connect(start_night)
	Global.finished_day.connect(next_day_transition)


func end_time_period():
	if Global.is_night:
		start_night()


func start_day():
	Global.transition.reset()
	night_light.energy = 1
	var tween := create_tween()
	tween.tween_property(night_light, "energy",0,sunset_duration)
	timer.wait_time = Global.DAY_DURATION_SECS
	timer.start()


func next_day_transition():
	Global.transition.fade_to_black()
	await get_tree().create_timer(1).timeout
	var heals = Global.player.current_hunger == Global.player.max_hunger
	for i in range(Global.DAY_HUNGER_LOSS):
		if i % 2 == 0 and heals:
			Global.player.heal(1)
		Global.player.lose_hunger(1)
		await get_tree().create_timer(1).timeout
	await get_tree().create_timer(2).timeout
	start_day()



func start_night():
	Global.is_night = true
	changing_time_period.emit()
	night_light.energy = 0
	var tween := create_tween()
	tween.tween_property(night_light, "energy",1,sunset_duration)
	timer.stop()
