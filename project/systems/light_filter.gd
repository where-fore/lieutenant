extends ColorRect

@export var day_colour:Color
@export var night_colour:Color


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	TimeOfDay.time_moved_forward.connect(step_light_forward)
	
	color = day_colour

func step_light_forward() -> void:
	var gradient_steps:Array[Color] = generate_color_steps(day_colour, night_colour, TimeOfDay.steps_per_day)
	
	var new_color:Color = gradient_steps[TimeOfDay.current_time_step - 1] #0 vs 1 indexed array
	
	transition_my_color(new_color)


var color_tween:Tween #hold reference
func transition_my_color(target_color:Color) -> void:
	var transition_duration:float = 0.7
	
	if color_tween and color_tween.is_valid(): #check in on that reference
		color_tween.kill()
	
	color_tween = create_tween()
	color_tween.tween_property(self, "color", target_color, transition_duration)

func generate_color_steps(start_color:Color, end_color:Color, number_of_steps:int) -> Array[Color]:
	var step_array:Array[Color]
	
	if number_of_steps < 3:
		push_error("wasn't given enough steps to generate a middle value: ", number_of_steps)
		return [start_color]
	
	for step:int in range(number_of_steps):
		var factor:float = float(step) / (number_of_steps-1)
		var interpolated_color:Color = start_color.lerp(end_color, factor)
		step_array.append(interpolated_color)
	
	return step_array
