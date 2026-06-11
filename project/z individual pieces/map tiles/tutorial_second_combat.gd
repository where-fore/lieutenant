extends MapTileData

func _init() -> void:
	tile_animation = load("res://z individual pieces/map tiles/animations/forest_basic.tres")
	enemies = [Database.get_combatant_by_id("tutorial_wolf"), Database.get_combatant_by_id("tutorial_wolf")]
	rewards = [Database.get_rewards_by_category(Categories.item_rarity, [Categories.Rarity.COMMON]).pick_random()]
	basic_reward = true
