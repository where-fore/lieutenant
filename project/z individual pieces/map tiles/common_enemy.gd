extends MapTileData

func _init() -> void:
	tile_animation = pick_animation()
	#scenario = load("res://z individual pieces/scenarios/test_scenario_fixed.gd").new()
	enemies = [Database.get_combatants_by_category(Categories.enemy_rarity, [Categories.Rarity.COMMON]).pick_random()]
	rewards = [Database.get_rewards_by_category(Categories.item_rarity, [Categories.Rarity.RARE]).pick_random()]
	chance_to_have_no_item(40)
	basic_reward = true

func pick_animation() -> SpriteFrames:
	var possible_animations:Array[SpriteFrames]
	possible_animations.append(load("res://z individual pieces/map tiles/animations/forest_basic.tres"))
	return possible_animations.pick_random()
