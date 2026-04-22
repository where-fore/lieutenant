extends Node2D

@onready var cursor_sprite:Sprite2D = $CanvasLayer/Sprite2D
@export var normal_cursor:Texture2D
@export var clicked_cursor:Texture2D
@onready var selection_border:Sprite2D = $CanvasLayer/Sprite2D/SelectionBorder
@onready var selection_sprite:Sprite2D = $CanvasLayer/Sprite2D/Selection

var click_change_timer:Timer
var click_change_duration:float = 0.25

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	validate_exports()
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	create_click_timer()
	HudEvents.reward_aiming.connect(setup_selection_from_reward)
	hide_selection()

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

func setup_selection_from_reward(reward:Reward) -> void:
	show_selection(reward.reward_sprite)

func show_selection(new_selection_sprite:Texture2D) -> void:
	selection_sprite.texture = new_selection_sprite
	selection_border.visible = true
	selection_sprite.visible = true

func hide_selection() -> void:
	selection_border.visible = false
	selection_sprite.visible = false

func validate_exports() -> void:
	var properties:Array[Dictionary] = get_property_list()
	
	for property:Dictionary in properties:
		# PROPERTY_USAGE_EDITOR means it shows up in the inspector (is an export)
		# PROPERTY_USAGE_SCRIPT_VARIABLE means it's part of this script, not the base node
		if property.usage & PROPERTY_USAGE_EDITOR and property.usage & PROPERTY_USAGE_SCRIPT_VARIABLE:
			var property_name:String = property["name"]
			var actual_exported:Variant = self.get(property_name)
			var my_name:String = self.name
			var error_message:String = "Export \"%s\" is not set in editor on node %s" % [property.name, my_name]
			match typeof(actual_exported):
				TYPE_OBJECT:
					if actual_exported == null:
						push_error(error_message)
				TYPE_STRING:
					if actual_exported.is_empty():
						push_error(error_message)
				TYPE_ARRAY:
					if actual_exported.is_empty():
						push_error(error_message)
				TYPE_DICTIONARY:
					if actual_exported.is_empty():
						push_error(error_message)
				TYPE_NIL:
					push_error(error_message)
