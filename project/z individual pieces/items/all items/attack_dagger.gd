extends Item

#basic setup
func setup_item_stats() -> void:
	reward_name = "Armor Piercer" # "Generic Item"
	reward_sprite = load("res://sprites/curved_dagger.png")
	extra_tooltip = "" # "Generic flavourful description"
	reward_categories = {
		Categories.item_rarity : Categories.Rarity.COMMON,
	}
	
	multiplicative_stat_dictionary[Stats.attack] = BalanceData.common_multiplicative_stat_budget


#custom stuff
