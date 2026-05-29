extends Aura

#whatever the aura does, doesn't do anything until you do something with it
var multiplier:int = 200

func setup_basic_aura_data() -> void:
	reward_name = "Striking" # "Generic aura"
	reward_sprite = load("res://sprites/sword_basic.png")
	extra_tooltip = "" # "Generic flavourful description"
	aura_categories = [] # [auraCategories.common_aura]

	duration_type = AuraNames.DurationType.TURNS
	base_duration = 3

#--functions called by aura_base.gd--
func setup_aura_stats() -> void:
	setup_basic_aura_data()
	
	#whatever the aura does
	multiplicative_stat_dictionary[Stats.attack] = multiplier

#--end of functions called by aura_base.gd--
