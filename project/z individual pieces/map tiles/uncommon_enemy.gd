extends MapTileData

func _init() -> void:
	tile_animation = pick_animation()
	enemies = [Database.get_combatants_by_category(Categories.enemy_rarity, [Categories.Rarity.RARE]).pick_random()]
	rewards = pick_rewards()
	basic_reward = true

func pick_animation() -> SpriteFrames:
	var possible_animations:Array[SpriteFrames]
	possible_animations.append(load("res://z individual pieces/map tiles/animations/forest_house1.tres"))
	possible_animations.append(load("res://z individual pieces/map tiles/animations/forest_house2.tres"))
	return possible_animations.pick_random()

#func pick_enemies() -> Array[Combatant]:
	#var rare_chance:int = 40
	#var rarity:Array[int]
	#if randi_range(1,100) < rare_chance:
		#rarity = [Categories.Rarity.RARE]
	#else: rarity = [Categories.Rarity.COMMON]
	#return [Database.get_combatants_by_category(Categories.enemy_rarity, rarity).pick_random()]

func pick_rewards() -> Array[Reward]:
	var rewards_to_return:Array[Reward]
	
	var common_item:Reward = Database.get_rewards_by_category(Categories.item_rarity, [Categories.Rarity.COMMON]).pick_random()
	rewards_to_return.append(common_item)
	
	var rare_chance:int = 100
	if randi_range(1,100) < rare_chance:
		rewards_to_return.append(Database.get_rewards_by_category(Categories.item_rarity, [Categories.Rarity.RARE]).pick_random())
	
	return rewards_to_return
