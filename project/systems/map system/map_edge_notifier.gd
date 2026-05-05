extends Node2D


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	print_debug("test")
	MapEvents.map_grid_right_edge_reached.emit()
