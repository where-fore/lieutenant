extends Item

#basic setup
func setup_item_stats() -> void:
	reward_name = "Iron Kite Shield" # "Generic Item"
	reward_sprite = load("res://sprites/small_shield.png")
	extra_tooltip = "" # "Generic flavourful description"
	reward_categories = {
		Categories.item_rarity : Categories.Rarity.COMMON,
	}
	
	multiplicative_stat_dictionary[Stats.fortitude] = BalanceData.basic_stat_scaling


#custom stuff
