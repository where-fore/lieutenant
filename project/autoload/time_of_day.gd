extends Node

signal time_moved_forward
signal new_day

var current_time_step:int
var current_day:int

var steps_per_day:int = 6
var starting_time_step:int = steps_per_day - 1 #magic number corresponding with the tutorial
var starting_day:int = 1

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
	new_day.emit()

func restart_clock() -> void:
	current_time_step = starting_time_step
	current_day = starting_day

func _ready() -> void:
	MapEvents.tile_all_done.connect(step_time_forward)
	TimingEvents.restarting_game.connect(restart_clock)
	restart_clock()
