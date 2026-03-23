extends Node

var unique_tile_id:String
var tile_data:MapTileData
var disabled:bool = false

@onready var animated_sprite_component:AnimatedSprite2D = $BaseAnimation
@onready var hover_animation_component:AnimatedSprite2D = $HoverAnimation

func apply_data(data:MapTileData) -> void:
	tile_data = data

	animated_sprite_component.sprite_frames = data.tile_animation
	animated_sprite_component.play()

func _init() -> void:
	unique_tile_id = str(get_instance_id()) + "_" + str(Time.get_time_string_from_system())

func _ready() -> void:
	hover_animation_component.visible = false
	
	animated_sprite_component.speed_scale = 0.2
	hover_animation_component.speed_scale = 0.8

func disable() -> void:
	disabled = true
	animated_sprite_component.modulate = Color(0.7,0.7,0.7,1)

func enable() -> void:
	disabled = false
	animated_sprite_component.modulate = Color(1,1,1,1)

func start_hover_animation() -> void:
	hover_animation_component.visible = true
	
	hover_animation_component.frame = 0
	hover_animation_component.play()

func stop_hover_animation() -> void:
	hover_animation_component.visible = false
	
	hover_animation_component.stop()

func when_clicked() -> void:
	pass

func _on_area_2d_mouse_entered() -> void:
	if not disabled:
		HudEvents.map_tile_hovered.emit(tile_data)
		start_hover_animation()

func _on_area_2d_mouse_exited() -> void:
	if not disabled:
		HudEvents.map_tile_unhovered.emit()
		stop_hover_animation()

func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if not disabled:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
				when_clicked()
