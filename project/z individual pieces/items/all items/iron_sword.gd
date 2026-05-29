extends Item

#basic item setup
func setup_item_stats() -> void:
	reward_name = "Iron Sword" # "Generic Item"
	reward_sprite = load("res://sprites/sword_basic.png")
	extra_tooltip = "" # "Generic flavourful description"
	item_categories = {
		Categories.item_rarity : Categories.Rarity.COMMON,
	}
	multiplicative_stat_dictionary[Stats.dexterity] = BalanceData.basic_stat_scaling


#custom stuff
