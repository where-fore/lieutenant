extends Aura

#whatever the aura does, doesn't do anything until you do something with it
var health_increase:int = BalanceData.rest_hp

func setup_basic_aura_data() -> void:
	aura_id = "rested" # "generic_aura"
	reward_name = "Well Rested" # "Generic aura"
	reward_sprite = load("res://sprites/heart.png")
	extra_tooltip = "" # "Generic flavourful description"
	aura_categories = [] # [auraCategories.common_aura]


#--functions called by aura_base.gd--
func setup_aura_stats() -> void:
	setup_basic_aura_data()
	#whatever the aura does
	additive_stat_dictionary[Stats.health] = health_increase

#--end of functions called by aura_base.gd--
