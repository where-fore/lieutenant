extends MapTileData

func _init() -> void:
	tile_animation = load("res://z individual pieces/map tiles/animations/forest_basic.tres")
	enemies = [Database.get_combatant_by_id("tutorial_wolf"), Database.get_combatant_by_id("tutorial_wolf")]
	rewards = pick_rewards()
	basic_reward = false

func pick_rewards() -> Array[Reward]:
	var number_of_rewards:int = 3
	
	var possible_rewards:Array[Reward] = Database.get_rewards_by_category(Categories.aura_rarity, [Categories.AuraRarity.BASIC_STAT])
	possible_rewards.shuffle()
	
	var chosen_rewards:Array[Reward]
	for i:int in number_of_rewards:
		chosen_rewards.append(possible_rewards.pop_front())
	
	return chosen_rewards
