extends Item

#basic setup
func setup_item_stats() -> void:
	reward_name = "Iron Axe" # "Generic Item"
	reward_sprite = load("res://sprites/items/basic_axe.png")
	extra_tooltip = "" # "Generic flavourful description"
	reward_categories = {
		Categories.item_rarity : Categories.Rarity.COMMON,
	}
	
	multiplicative_stat_dictionary[Stats.strength] = BalanceData.basic_stat_scaling


#custom stuff
