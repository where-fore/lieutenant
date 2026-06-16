extends Item

#basic setup
func setup_item_stats() -> void:
	reward_name = "Fallen Paladin's Armor" # "Generic Item"
	reward_sprite = load("res://sprites/items/shining_armour.png")
	extra_tooltip = "" # "Generic flavourful description"
	reward_categories = {
		Categories.item_rarity : Categories.Rarity.RARE,
	}
	
	multiplicative_stat_dictionary[Stats.fortitude] = BalanceData.rare_multiplicative_stat_budget / 2
	multiplicative_stat_dictionary[Stats.health] = BalanceData.rare_multiplicative_stat_budget / 2


#custom stuff
