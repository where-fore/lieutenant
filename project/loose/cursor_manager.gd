extends Node2D

@onready var cursor_sprite:Sprite2D = $CanvasLayer/Sprite2D
@export var normal_cursor:Texture2D
@export var clicked_cursor:Texture2D

var click_change_timer:Timer
var click_change_duration:float = 0.25

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	check_for_errors()
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	create_click_timer()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		cursor_sprite.global_position = event.position
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				cursor_sprite.texture = clicked_cursor
				click_change_timer.stop()
			else:
				click_change_timer.start()

# can listen to signals (eg. mouse entered enemy clickbox) and then first a function with
# Input.set_custom_mouse_cursor(new_cursor_picture_here)

func create_click_timer() -> void:
	click_change_timer = Timer.new()
	click_change_timer.one_shot = true
	click_change_timer.autostart = false
	click_change_timer.wait_time = click_change_duration
	add_child(click_change_timer)
	click_change_timer.timeout.connect(swap_to_normal_sprite)

func swap_to_normal_sprite() -> void:
	cursor_sprite.texture = normal_cursor

func check_for_errors() -> void:
	if not normal_cursor: push_error("cursor normal texture not set")
	if not clicked_cursor: push_error("cursor clicked texture not set")
