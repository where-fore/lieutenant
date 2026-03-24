extends MapTileData

func _init() -> void:
	tile_animation = load("res://z individual pieces/map tiles/forest_basic.tres")
	item_reward = Database.get_items_by_category(Categories.item_rarity, Categories.Rarity.COMMON).pick_random()
	enemy = Database.get_combatants_by_category(Categories.enemy_rarity, Categories.Rarity.COMMON).pick_random()
