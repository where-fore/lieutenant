extends Item

#basic item setup
func setup_item_stats() -> void:
	reward_name = "Fallen Paladin's Armor" # "Generic Item"
	reward_sprite = load("res://sprites/items/shining_armour.png")
	extra_tooltip = "" # "Generic flavourful description"
	item_categories = {
		Categories.item_rarity : Categories.Rarity.RARE,
	}
	
	multiplicative_stat_dictionary[Stats.health] = BalanceData.basic_stat_scaling * 4


#custom stuff
