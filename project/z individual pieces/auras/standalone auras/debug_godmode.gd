extends Aura

#whatever the aura does, doesn't do anything until you do something with it
var str_increase:int = BalanceData.player_base_strength * 10000
var dex_increase:int = BalanceData.player_base_dexterity * 10000

func setup_basic_aura_data() -> void:
	aura_id = "debug_godmode" # "generic_aura"
	reward_name = "Ascended beyond Binary" # "Generic aura"
	reward_sprite = load("res://sprites/heart_purple.png")
	extra_tooltip = "Debug mode activated!" # "Generic flavourful description"
	aura_categories = [] # [auraCategories.common_aura]


#--functions called by aura_base.gd--
func setup_aura_stats() -> void:
	setup_basic_aura_data()
	#whatever the aura does
	additive_stat_dictionary[Stats.strength] = str_increase
	additive_stat_dictionary[Stats.dexterity] = dex_increase

#--end of functions called by aura_base.gd--
