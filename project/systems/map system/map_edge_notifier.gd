extends Node2D
class_name MapEdgeNotifier

var is_left_side_edge:bool = false
var is_right_side_edge:bool = false

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	if is_left_side_edge:
		MapEvents.map_grid_left_edge_visible.emit(true)
	elif is_right_side_edge:
		MapEvents.map_grid_right_edge_visible.emit(true)
	else:
		push_error("map edge notifier wasn't set to be a specific side, at: ", self.global_position)

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	if is_left_side_edge:
		MapEvents.map_grid_left_edge_visible.emit(false)
	elif is_right_side_edge:
		MapEvents.map_grid_right_edge_visible.emit(false)
	else:
		push_error("map edge notifier wasn't set to be a specific side, at: ", self.global_position)
