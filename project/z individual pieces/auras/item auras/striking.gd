extends Aura

#basic setup
func setup_aura_stats() -> void:
	reward_name = "Striking" # "Generic aura"
	reward_sprite = load("res://sprites/sword_basic.png")
	extra_tooltip = "" # "Generic flavourful description"
	aura_categories = [] # [auraCategories.common_aura]

	duration_type = AuraNames.DurationType.TURNS
	base_duration = 2
	
	multiplicative_stat_dictionary[Stats.attack] = my_public_multiplier


#custom stuff
var my_public_multiplier:int = BalanceData.rare_multiplicative_stat_budget * 3
