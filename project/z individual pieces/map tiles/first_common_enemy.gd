extends MapTileData

func _init() -> void:
	tile_animation = pick_animation()
	enemies = [Database.get_combatants_by_category(Categories.enemy_rarity, [Categories.Rarity.COMMON]).pick_random()]
	rewards = [Database.get_rewards_by_category(Categories.item_rarity, [Categories.Rarity.COMMON]).pick_random()]

func pick_animation() -> SpriteFrames:
	var possible_animations:Array[SpriteFrames]
	possible_animations.append(load("res://z individual pieces/map tiles/animations/forest_house1.tres"))
	possible_animations.append(load("res://z individual pieces/map tiles/animations/forest_house2.tres"))
	return possible_animations.pick_random()
