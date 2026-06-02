extends MapTileData

func _init() -> void:
	tile_animation = load("res://z individual pieces/map tiles/animations/forest_plains.tres")
	scenario = load("res://z individual pieces/scenarios/knights_join_party.gd").new()
