extends Item

#basic setup
func setup_item_stats() -> void:
	reward_name = "Ring of the Vitruvian" # "Generic Item"
	reward_sprite = load("res://sprites/gaudy_ruby_ring.png")
	extra_tooltip = "" # "Generic flavourful description"
	reward_categories = {
		Categories.item_rarity : Categories.Rarity.RARE,
	}
	
	for stat:StringName in Stats.attributes:
		multiplicative_stat_dictionary[stat] = BalanceData.rare_multiplicative_stat_budget / 2


#custom stuff
