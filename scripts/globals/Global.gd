extends Node
class_name Globals

const TILEMAP_SIZE = 16

const DAY_DURATION_SECS = 10
const SUNSET_DURATION_SECS = 5
const TOTAL_DAYS = 5

var is_night: bool = false
var current_day = 1

signal finished_day

@onready var scene = get_node("/root/Game")
var transition:TransitionScreen

func _ready():
	finished_day.connect(next_day)

func next_day():
	current_day += 1
