extends Item

#basic item setup
func setup_item_stats() -> void:
	reward_name = "Iron Dirk" # "Generic Item"
	reward_sprite = load("res://sprites/dirk.png")
	extra_tooltip = "" # "Generic flavourful description"
	item_categories = {
		Categories.item_rarity : Categories.Rarity.COMMON,
	}
	additive_stat_dictionary[Stats.dexterity] = BalanceData.basic_stat


#custom stuff
