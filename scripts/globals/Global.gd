extends Node
class_name Globals

const TILEMAP_SIZE = 16

const DAY_DURATION_SECS = 10
const SUNSET_DURATION_SECS = 5
const TOTAL_DAYS = 5

var is_night: bool = false
var current_day = 1

@onready var scene = get_node("/root/Game")
var transition:TransitionScreen

