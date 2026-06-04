extends Item

#basic setup
func setup_item_stats() -> void:
	reward_name = "Fallen Paladin's Armor" # "Generic Item"
	reward_sprite = load("res://sprites/items/shining_armour.png")
	extra_tooltip = "" # "Generic flavourful description"
	reward_categories = {
		Categories.item_rarity : Categories.Rarity.COMMON,
	}
	
	multiplicative_stat_dictionary[Stats.fortitude] = BalanceData.common_multiplicative_stat_budget
	multiplicative_stat_dictionary[Stats.health] = BalanceData.common_multiplicative_stat_budget


#custom stuff
