extends Item

#basic item setup
func setup_item_stats() -> void:
	reward_name = "Iron Round Shield" # "Generic Item"
	reward_sprite = load("res://sprites/items/small_shield.png")
	extra_tooltip = "" # "Generic flavourful description"
	item_categories = {
		Categories.item_rarity : Categories.Rarity.COMMON,
	}
	
	additive_stat_dictionary[Stats.health] = BalanceData.basic_health


#custom stuff
