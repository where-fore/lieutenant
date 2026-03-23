extends Node

var unique_tile_id:String
var tile_data:MapTileData
var tile_animation:SpriteFrames
@onready var animated_sprite_component:AnimatedSprite2D = $BaseAnimation
@onready var hover_animation_component:AnimatedSprite2D = $HoverAnimation

func apply_data(data:MapTileData) -> void:
	tile_data = data
	
	tile_animation = data.tile_animation
	animated_sprite_component.sprite_frames = tile_animation
	animated_sprite_component.play()

func _init() -> void:
	unique_tile_id = str(get_instance_id()) + "_" + str(Time.get_time_string_from_system())

func _ready() -> void:
	hover_animation_component.visible = false
	
	animated_sprite_component.speed_scale = 0.2
	hover_animation_component.speed_scale = 0.8

func _on_area_2d_mouse_entered() -> void:
	start_hover_animation()

func _on_area_2d_mouse_exited() -> void:
	stop_hover_animation()

func start_hover_animation() -> void:
	hover_animation_component.visible = true
	
	hover_animation_component.frame = 0
	hover_animation_component.play()

func stop_hover_animation() -> void:
	hover_animation_component.visible = false
	
	hover_animation_component.stop()
	
