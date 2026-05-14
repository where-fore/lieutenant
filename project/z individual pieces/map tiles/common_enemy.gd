extends MapTileData

func _init() -> void:
	internal_name = "common enemy"
	tile_animation = pick_animation()
	#scenario = load("res://z individual pieces/scenarios/test_scenario_fixed.gd").new()
	enemies = [Database.get_combatant_by_id("skeleton_behemoth")]
	#enemies = [Database.get_combatants_by_category(Categories.enemy_rarity, [Categories.Rarity.COMMON]).pick_random()]
	reward = Database.get_items_by_category(Categories.item_rarity, [Categories.Rarity.COMMON]).pick_random()

func pick_animation() -> SpriteFrames:
	var possible_animations:Array[SpriteFrames]
	possible_animations.append(load("res://z individual pieces/map tiles/animations/forest_plains.tres"))
	return possible_animations.pick_random()
