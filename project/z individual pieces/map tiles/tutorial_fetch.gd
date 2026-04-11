extends MapTileData

func _init() -> void:
	internal_name = "first reward house"
	tile_animation = load("res://z individual pieces/map tiles/animations/forest_plains.tres")
	enemy = Database.get_combatant_by_id("tutorial_wolf") #basic_skeleton
	#item reward populated by map spawner, since i want non-overlapping items
