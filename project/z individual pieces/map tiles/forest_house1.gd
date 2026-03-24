extends MapTileData

func _init() -> void:
	tile_animation = load("res://z individual pieces/map tiles/forest_house1.tres")
	aura_reward = load("res://z individual pieces/auras/standalone auras/rested.gd").new().create_aura()
