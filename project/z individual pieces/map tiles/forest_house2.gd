extends MapTileData

func _init() -> void:
	tile_animation = load("res://z individual pieces/map tiles/animations/forest_house2.tres")
	enemies = [Database.get_combatants_by_category(Categories.enemy_rarity, [Categories.Rarity.RARE]).pick_random()]
