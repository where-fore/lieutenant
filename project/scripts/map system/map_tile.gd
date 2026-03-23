extends Node

var tile_data:MapTileData
var tile_animation:SpriteFrames
@onready var animated_sprite_component:AnimatedSprite2D = $AnimatedSprite2D

func apply_data(data:MapTileData) -> void:
	tile_data = data
	
	tile_animation = data.tile_animation
	animated_sprite_component.sprite_frames = tile_animation
	animated_sprite_component.speed_scale = 0.2
	animated_sprite_component.play()
