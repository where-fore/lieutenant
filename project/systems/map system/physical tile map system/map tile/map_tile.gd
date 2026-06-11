extends Node2D
class_name MapTile

var tile_data:MapTileData
var currently_disabled:bool = false
var permanently_disabled:bool = false
var permanently_enabled:bool = false
var permanently_visible:bool = false
var player_has_been_here:bool = false
var end_of_chapter:bool = false
var lethal_encounter:bool = false
## 0,0 is the first tile spawned
var x_coordinate:int
## 0,0 is the first tile spawned
var y_coordinate:int
var width:int

@export var tooltip_holder:Control
@export var info_panel_container:Control
@onready var animated_sprite_component:AnimatedSprite2D = $BaseAnimation
var idle_animation_speed:float = 0.2
@onready var hover_animation_component:AnimatedSprite2D = $HoverAnimation
var hover_animation_speed:float = 0.8
@onready var selection_sprite:Sprite2D = $SelectionAnimation
@onready var selection_effect_timer:Timer = $SelectionAnimation/Timer
@onready var player_indicator:AnimatedSprite2D = $PlayerIndicator
@onready var clickbox_polygon:CollisionPolygon2D = $Clickbox/CollisionPolygon2D

var scenario_for_retreading:Scenario = load("res://z individual pieces/scenarios/retreading_base.gd").new()

func apply_data(data:MapTileData) -> void:
	tile_data = data
	tile_data.apply_to_tile(self)
	tile_data.setup()

	if not tile_data.tile_animation:
		push_error("no animation set for tile: " + "\"" + tile_data.script_path + "\"")
	animated_sprite_component.sprite_frames = data.tile_animation
	animated_sprite_component.play()

func _ready() -> void:
	@warning_ignore("untyped_declaration") #programmer short hand for yeeting all the arguments
	MapEvents.venture_to.connect(func(_unused_data) -> void: stop_hover_animation())
	HudEvents.map_tile_hovered.connect(if_not_me_stop_hovering)
	MapEvents.venture_to.connect(show_player_indicator_if_match)
	
	info_panel_container.visible = false
	hover_animation_component.visible = false
	selection_sprite.visible = false
	tooltip_holder.visible = false
	hide_player_indicator()
	
	animated_sprite_component.speed_scale = idle_animation_speed
	hover_animation_component.speed_scale = hover_animation_speed
	var frames_in_hover_animation:int = hover_animation_component.sprite_frames.get_frame_count(hover_animation_component.animation)
	selection_effect_timer.wait_time = hover_animation_speed / frames_in_hover_animation

func new_day_check() -> void:
	if tile_data:
		tile_data.generate_encounters()
		tile_data.scale_stats()
		HudEvents.map_tile_updated.emit(self)
	else:
		push_error("tile at x: ", x_coordinate, ", y: ", y_coordinate, " had no tile_data declared")

func encounter_this_tile() -> void:
	if tile_data.scenario:
		tile_data.scenario.encounter_this_scenario()
		MapEvents.enter_scenario_in.emit(self)
	elif tile_data.enemies:
		MapEvents.enter_combat_in.emit(self)
	else:
		MapEvents.enter_without_combat_in.emit(self)

func mark_as_boss() -> void:
	end_of_chapter = true
	lethal_encounter = true
	make_permanently_visible()
	disable()

func clear_objects_of_interest() -> void:
	tile_data.enemies = []
	tile_data.rewards = []
	tile_data.scenario = scenario_for_retreading

func make_permanently_visible() -> void:
	permanently_visible = true
	animated_sprite_component.modulate = Color(1,1,1,1)

func remove_permanently_visibility() -> void:
	permanently_visible = false
	if currently_disabled:
		disable()
	else:
		enable()

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
			animated_sprite_component.modulate = Color(0.1,0.1,0.1,1)

func disable() -> void:
	if not currently_disabled and not permanently_disabled and not permanently_enabled:
		stop_hover_animation()
		currently_disabled = true
		if not permanently_visible:
			animated_sprite_component.modulate = Color(0.3,0.3,0.3,1)

func enable() -> void:
	if not permanently_disabled:
		currently_disabled = false
		animated_sprite_component.modulate = Color(1,1,1,1)

func show_player_indicator_if_match(maptile:MapTile) -> void:
	hide_player_indicator()
	if maptile == self:
		player_indicator.visible = true

func hide_player_indicator() -> void:
	player_indicator.visible = false

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
		show_info_panel()

func when_hovered() -> void:
	if currently_disabled and not permanently_disabled:
		tooltip_holder.visible = true

func when_unhovered() -> void:
	tooltip_holder.visible = false

func if_not_me_stop_hovering(maptile:MapTile) -> void:
	if maptile != self:
		hide_selection_effect()
		stop_hover_animation()
		hide_info_panel()

func show_info_panel() -> void:
	info_panel_container.update_map_tile_info(self)
	info_panel_container.visible = true

func hide_info_panel() -> void:
	info_panel_container.visible = false

func show_selection_effect() -> void:
	selection_sprite.visible = true
	selection_effect_timer.start()

func hide_selection_effect() -> void:
	selection_sprite.visible = false

func _on_timer_timeout() -> void:
	hide_selection_effect()

func _unhandled_input(event: InputEvent) -> void:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
				var polygon_points:PackedVector2Array = clickbox_polygon.polygon
				if Geometry2D.is_point_in_polygon(to_local(event.global_position), polygon_points):
					when_clicked()

func _on_clickbox_mouse_entered() -> void:
	when_hovered()

func _on_clickbox_mouse_exited() -> void:
	when_unhovered()
