extends MapTileData

func _init() -> void:
	internal_name = "basic forest"
	tile_animation = load("res://z individual pieces/map tiles/forest_basic.tres")
	item_reward = Database.get_items_by_category(Categories.item_rarity, Categories.Rarity.COMMON).pick_random()
	enemy = Database.get_combatants_by_category(Categories.enemy_rarity, Categories.Rarity.COMMON).pick_random()

	var rare_chance:int = 40
	var common_chance:int = 100-rare_chance
	var roll:int = randi_range(1,100)
	if roll <= rare_chance:
		item_reward = Database.get_items_by_category(Categories.item_rarity, Categories.Rarity.RARE).pick_random()
	elif roll <= rare_chance + common_chance:
		item_reward = Database.get_items_by_category(Categories.item_rarity, Categories.Rarity.COMMON).pick_random()
	else:
		item_reward = Database.get_item_by_id("rock")
