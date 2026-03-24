extends MapTileData

func _init() -> void:
	tile_animation = load("res://z individual pieces/map tiles/forest_plains.tres")
	enemy = Database.get_combatants_by_category(Categories.enemy_rarity, Categories.Rarity.MYTHIC).pick_random()
