extends MapTileData

func _init() -> void:
	internal_name = "rare enemy"
	tile_animation = load("res://z individual pieces/map tiles/animations/forest_basic.tres")
	enemy = Database.get_combatants_by_category(Categories.enemy_rarity, [Categories.Rarity.MYTHIC]).pick_random()
	item_reward = choose_item_reward()
	stops_vision = true

func choose_item_reward() -> Item:
	var mythic_chance:int = 2
	var random_roll:int = randi_range(1,100)
	if random_roll <= mythic_chance:
		return Database.get_items_by_category(Categories.item_rarity, [Categories.Rarity.MYTHIC]).pick_random()
	else:
		return Database.get_items_by_category(Categories.item_rarity, [Categories.Rarity.RARE]).pick_random()
