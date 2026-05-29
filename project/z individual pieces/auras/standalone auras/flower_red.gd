extends Aura

#basic setup
func setup_aura_stats() -> void:
	reward_name = "Sunthistle" # "Generic aura"
	reward_sprite = load("res://sprites/flower_red.png")
	extra_tooltip = "" # "Generic flavourful description"
	reward_categories = {Categories.aura_rarity: Categories.AuraRarity.BASIC_STAT}
	
	additive_stat_dictionary[Stats.strength] = BalanceData.flower_basic_stat


#custom stuff
