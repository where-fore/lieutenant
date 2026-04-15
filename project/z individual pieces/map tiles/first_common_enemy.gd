extends MapTileData

func _init() -> void:
	internal_name = "common enemy"
	tile_animation = pick_animation()
	enemy = Database.get_combatants_by_category(Categories.enemy_rarity, [Categories.Rarity.COMMON]).pick_random()
	item_reward = Database.get_items_by_category(Categories.item_rarity, [Categories.Rarity.COMMON]).pick_random()

func pick_animation() -> SpriteFrames:
	var possible_animations:Array[SpriteFrames]
	possible_animations.append(load("res://z individual pieces/map tiles/animations/forest_house1.tres"))
	possible_animations.append(load("res://z individual pieces/map tiles/animations/forest_house2.tres"))
	return possible_animations.pick_random()


#old
#func apply_to_tile(parent_tile:MapTile) -> void:
	#var base_mythic_chance:int = 0
	#var mythic_chance_increase:int = parent_tile.power / 2
	#var base_rare_chance:int = 30
	#var rare_chance_increase:int = parent_tile.power * 7 #want power 12,13,14 to be 100%
	#generate_item_reward_chance_by_power(base_rare_chance, rare_chance_increase, base_mythic_chance, mythic_chance_increase)
	##print_debug("generated " + item_reward.item_name + " at tile: " + str(parent_tile.x_coordinate) + ", " + str(parent_tile.y_coordinate))
