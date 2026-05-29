extends Item

#basic setup
func setup_item_stats() -> void:
	reward_name = "Iron Round Shield" # "Generic Item"
	reward_sprite = load("res://sprites/items/small_shield.png")
	extra_tooltip = "" # "Generic flavourful description"
	reward_categories = {
		Categories.item_rarity : Categories.Rarity.COMMON,
	}
	
	additive_stat_dictionary[Stats.fortitude] = BalanceData.player_base_fortitude


#custom stuff
