extends Node

@export var timer: Timer
@export var night_light: DirectionalLight2D

@export var sunset_duration: float = Global.SUNSET_DURATION_SECS

signal changing_time_period

func _ready() -> void:
	timer.wait_time = Global.DAY_DURATION_SECS
	timer.start()
	timer.timeout.connect(end_time_period)


func end_time_period():
	Global.is_night = !Global.is_night
	changing_time_period.emit()
	if Global.is_night:
		start_night()
	else:
		start_day()


func start_day():
	night_light.energy = 1
	var tween := create_tween()
	tween.tween_property(night_light, "energy",0,sunset_duration)
	timer.wait_time = Global.DAY_DURATION_SECS
	timer.start()


func start_night():
	night_light.energy = 0
	var tween := create_tween()
	tween.tween_property(night_light, "energy",1,sunset_duration)
	timer.wait_time = Global.NIGHT_DURATION_SECS
	timer.start()
