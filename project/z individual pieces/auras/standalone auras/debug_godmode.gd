extends Aura

#whatever the aura does, doesn't do anything until you do something with it
var health_increase:int = BalanceData.player_base_health * 100
var attack_increase:int = BalanceData.player_base_attack * 100

func setup_basic_aura_data() -> void:
	aura_id = "debug_godmode" # "generic_aura"
	aura_name = "Ascended from Binary" # "Generic aura"
	aura_sprite = load("res://sprites/heart_purple.png")
	extra_tooltip = "Developers only!" # "Generic flavourful description"
	aura_categories = [] # [auraCategories.common_aura]


#--functions called by aura_base.gd--
func setup_aura_stats() -> void:
	setup_basic_aura_data()
	#whatever the aura does
	additive_stat_dictionary[Stats.health] = health_increase
	additive_stat_dictionary[Stats.attack] = attack_increase

#--end of functions called by aura_base.gd--
