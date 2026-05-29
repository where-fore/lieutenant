extends Item

#basic setup
func setup_item_stats() -> void:
	reward_name = "Iron Handaxe" # "Generic Item"
	reward_sprite = load("res://sprites/iron_axe.png")
	extra_tooltip = "" # "Generic flavourful description"
	reward_categories = {
		Categories.item_rarity : Categories.Rarity.COMMON,
	}
	additive_stat_dictionary[Stats.strength] = BalanceData.basic_stat


#custom stuff
