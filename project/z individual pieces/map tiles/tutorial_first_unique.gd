extends MapTileData

func _init() -> void:
	tile_animation = load("res://z individual pieces/map tiles/animations/forest_basic.tres")
	enemies = [Database.get_combatant_by_id("basic_skeleton")] #basic_skeleton
	#item reward populated by map spawner, since i want non-overlapping items
