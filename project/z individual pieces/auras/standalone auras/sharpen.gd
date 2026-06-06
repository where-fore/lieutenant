extends Aura

#basic setup
func setup_aura_stats() -> void:
	reward_name = "Sharpened Weapon" # "Generic aura"
	reward_sprite = load("res://sprites/sword_basic.png")
	extra_tooltip = "" # "Generic flavourful description"
	aura_categories = [] # [auraCategories.common_aura]
	
	additive_stat_dictionary[Stats.attack] = BalanceData.basic_attack


#custom stuff
