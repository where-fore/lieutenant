extends Control


func _on_restart_button_pressed() -> void:
	HudEvents.rout_chosen.emit()
