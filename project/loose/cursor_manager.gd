extends Node2D

@export var default_cursor:Texture2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not default_cursor: push_error("cursor texture not set")
	Input.set_custom_mouse_cursor(default_cursor)

# can listen to signals (eg. mouse entered enemy clickbox) and then first a function with
# Input.set_custom_mouse_cursor(new_cursor_picture_here)
