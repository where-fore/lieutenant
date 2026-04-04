extends MapTileData

func _init() -> void:
	internal_name = "basic plains"
	tile_animation = load("res://z individual pieces/map tiles/forest_plains.tres")
	enemy = Database.get_combatants_by_category(Categories.enemy_rarity, [Categories.Rarity.MYTHIC]).pick_random()
	item_reward = Database.get_items_by_category(Categories.item_rarity, [Categories.Rarity.RARE,Categories.Rarity.MYTHIC]).pick_random()
	
