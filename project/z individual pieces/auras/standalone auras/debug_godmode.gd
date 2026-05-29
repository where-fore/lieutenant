extends Aura

func setup_basic_aura_data() -> void:
	aura_id = "debug_godmode" # "generic_aura"
	reward_name = "Ascended beyond Binary" # "Generic aura"
	reward_sprite = load("res://sprites/heart.png")
	extra_tooltip = "Debug mode activated!" # "Generic flavourful description"
	aura_categories = [] # [auraCategories.common_aura]
	
	additive_stat_dictionary[Stats.health] = 1000000
	additive_stat_dictionary[Stats.attack] = 1000000
