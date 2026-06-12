extends Aura

#basic setup
func setup_aura_stats() -> void:
	reward_name = "Well Rested" # "Generic aura"
	reward_sprite = load("res://sprites/heart.png")
	extra_tooltip = "" # "Generic flavourful description"
	aura_categories = [] # [auraCategories.common_aura]
	
	additive_stat_dictionary[Stats.health] = BalanceData.basic_health


#custom stuff
