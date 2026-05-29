extends Item

#basic item setup
func setup_item_stats() -> void:
	reward_name = "Iron Buckler" # "Generic Item"
	reward_sprite = load("res://sprites/small_buckler.png")
	extra_tooltip = "" # "Generic flavourful description"
	item_categories = {
		Categories.item_rarity : Categories.Rarity.COMMON,
	}
	multiplicative_stat_dictionary[Stats.health] = BalanceData.basic_stat_scaling


#custom stuff
