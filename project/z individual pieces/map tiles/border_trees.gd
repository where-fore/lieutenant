extends MapTileData

func _init() -> void:
	tile_animation = load("res://z individual pieces/map tiles/animations/forest_basic.tres")

func apply_to_tile(parent_tile:MapTile) -> void:
	parent_tile.permanently_disable()
