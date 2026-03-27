extends Node
class_name MapTile

var unique_tile_id:String
var tile_data:MapTileData
var currently_disabled:bool = false
var permanently_disabled:bool = false
var permanently_enabled:bool = false
var permanently_visible:bool = false
var end_of_chapter:bool = false
var lethal_encounter:bool = false
## 0,0 is the first tile spawned
var x_coordinate:int
## 0,0 is the first tile spawned
var y_coordinate:int

@onready var animated_sprite_component:AnimatedSprite2D = $BaseAnimation
var idle_animation_speed:float = 0.2
@onready var hover_animation_component:AnimatedSprite2D = $HoverAnimation
var hover_animation_speed:float = 0.8
@onready var selection_sprite:Sprite2D = $Sprite2D
@onready var selection_effect_timer:Timer = $Sprite2D/Timer

func apply_data(data:MapTileData) -> void:
	tile_data = data

	if not tile_data.tile_animation:
		push_error("no animation set for tile: " + "\"" + tile_data.internal_name + "\"")
	animated_sprite_component.sprite_frames = data.tile_animation
	animated_sprite_component.play()

func _init() -> void:
	unique_tile_id = str(ResourceUID.create_id())

func _ready() -> void:
	MapEvents.combat_all_done.connect(stop_hover_animation)
	HudEvents.map_tile_hovered.connect(if_not_me_stop_hovering)
	
	hover_animation_component.visible = false
	selection_sprite.visible = false
	
	animated_sprite_component.speed_scale = idle_animation_speed
	hover_animation_component.speed_scale = hover_animation_speed
	var frames_in_hover_animation:int = hover_animation_component.sprite_frames.get_frame_count(hover_animation_component.animation)
	selection_effect_timer.wait_time = hover_animation_speed / frames_in_hover_animation

func mark_as_boss() -> void:
	end_of_chapter = true
	lethal_encounter = true
	make_permanently_visible()
	disable()

func make_permanently_visible() -> void:
	permanently_visible = true
	animated_sprite_component.modulate = Color(1,1,1,1)

func permanently_enable() -> void:
	currently_disabled = false
	permanently_disabled = false
	enable()
	permanently_enabled = true

func permanently_disable() -> void:
	if not permanently_enabled:
		stop_hover_animation()
		currently_disabled = true
		permanently_disabled = true
		if not permanently_visible:
			animated_sprite_component.modulate = Color(0.3,0.3,0.3,1)

func disable() -> void:
	if not currently_disabled and not permanently_disabled and not permanently_enabled:
		stop_hover_animation()
		currently_disabled = true
		if not permanently_visible:
			animated_sprite_component.modulate = Color(0.4,0.4,0.4,1)

func enable() -> void:
	if currently_disabled and not permanently_disabled:
		currently_disabled = false
		animated_sprite_component.modulate = Color(1,1,1,1)

func start_hover_animation() -> void:
	hover_animation_component.visible = true
	
	if not hover_animation_component.is_playing():
		hover_animation_component.frame = 0
		hover_animation_component.play()

func stop_hover_animation() -> void:
	hover_animation_component.visible = false
	
	hover_animation_component.stop()

func when_clicked() -> void:
	if not currently_disabled or permanently_visible:
		HudEvents.map_tile_hovered.emit(self)
		start_hover_animation()
		show_selection_effect()

func if_not_me_stop_hovering(maptile:MapTile) -> void:
	if maptile != self:
		hide_selection_effect()
		stop_hover_animation()

func _on_area_2d_mouse_entered() -> void:
	pass

func _on_area_2d_mouse_exited() -> void:
	pass

func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			when_clicked()

func show_selection_effect() -> void:
	selection_sprite.visible = true
	selection_effect_timer.start()

func hide_selection_effect() -> void:
	selection_sprite.visible = false

func _on_timer_timeout() -> void:
	hide_selection_effect()
