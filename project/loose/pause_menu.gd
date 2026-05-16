extends Control

@onready var math_info_panel:Control = $MathInfoPanel

func _ready() -> void:
	math_info_panel.visible = false

func _on_save_game_button_pressed() -> void:
	SaveManager.save_game()

func _on_info_button_pressed() -> void:
	math_info_panel.visible = true

func _on_close_button_pressed() -> void:
	math_info_panel.visible = false
