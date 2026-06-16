extends Item

#basic setup
func setup_item_stats() -> void:
	reward_name = "Iron Kite Shield" # "Generic Item"
	reward_sprite = load("res://sprites/small_shield.png")
	extra_tooltip = "" # "Generic flavourful description"
	reward_categories = {
		Categories.item_rarity : Categories.Rarity.RARE,
	}
	
	multiplicative_stat_dictionary[Stats.fortitude] = BalanceData.rare_multiplicative_stat_budget / 2
	multiplicative_stat_dictionary[Stats.strength] = BalanceData.rare_multiplicative_stat_budget / 2


#custom stuff
