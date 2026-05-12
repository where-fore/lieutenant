extends MapTileData

func _init() -> void:
	internal_name = "basic plains"
	tile_animation = load("res://z individual pieces/map tiles/animations/forest_plains.tres")
	enemies = [Database.get_combatant_by_id("skeleton_regent")]
