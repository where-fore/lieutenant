extends Node

signal time_moved_forward()

var current_time_step:int = 1
var current_day:int = 1

var steps_per_day:int = 4

func step_time_forward() -> void:
	if current_time_step == steps_per_day:
		next_day()
	elif current_time_step < steps_per_day:
		current_time_step += 1
	else:
		push_error("got confused with time steps, called at time step: ", current_time_step, ", out of ", steps_per_day)
	time_moved_forward.emit()

func next_day() -> void:
	current_time_step = 1
	current_day += 1

func _ready() -> void:
	MapEvents.tile_all_done.connect(step_time_forward)
