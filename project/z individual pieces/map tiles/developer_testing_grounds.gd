extends MapTileData

func _init() -> void:
	tile_animation = load("res://z individual pieces/map tiles/animations/forest_basic.tres")
	enemies = [Database.get_combatant_by_id("developer_target_dummy")]
