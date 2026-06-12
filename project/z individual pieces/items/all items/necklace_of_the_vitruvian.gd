extends Item

#basic setup
func setup_item_stats() -> void:
	reward_name = "Necklace of the Vitruvian" # "Generic Item"
	reward_sprite = load("res://sprites/adorned_ruby_necklace.png")
	extra_tooltip = "" # "Generic flavourful description"
	reward_categories = {
		Categories.item_rarity : Categories.Rarity.COMMON,
	}
	
	for stat:StringName in Stats.attributes:
		additive_stat_dictionary[stat] = BalanceData.common_stat_budget


#custom stuff
