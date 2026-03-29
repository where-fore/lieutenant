extends MapTileData

func _init() -> void:
	internal_name = "basic forest"
	tile_animation = load("res://z individual pieces/map tiles/forest_basic.tres")
	enemy = Database.get_combatants_by_category(Categories.enemy_rarity, Categories.Rarity.COMMON).pick_random()
	#item reward populated by map spawner, since i different chances based on distance
