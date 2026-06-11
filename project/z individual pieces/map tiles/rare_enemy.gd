extends MapTileData

func _init() -> void:
	tile_animation = load("res://z individual pieces/map tiles/animations/forest_plains.tres")
	enemies = [Database.get_combatants_by_category(Categories.enemy_rarity, [Categories.Rarity.MYTHIC]).pick_random()]
	rewards = pick_rare_rewards(3)
	stops_vision = true
	basic_reward = true

func pick_rare_rewards(number_to_pick:int) -> Array[Reward]:
	var rewards_to_return:Array[Reward]
	
	var rare_items_list:Array[Reward] = Database.get_rewards_by_category(Categories.item_rarity, [Categories.Rarity.RARE])
	rare_items_list.shuffle()
	for i:int in number_to_pick:
		rewards_to_return.append(rare_items_list.pop_front())

	return rewards_to_return
