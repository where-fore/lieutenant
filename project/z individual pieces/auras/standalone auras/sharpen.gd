extends Aura

#whatever the aura does, doesn't do anything until you do something with it
var attack_increase:int = BalanceData.sharpen_attack

func setup_basic_aura_data() -> void:
	aura_id = "sharpen" # "generic_aura"
	reward_name = "Sharpened Weapon" # "Generic aura"
	reward_sprite = load("res://sprites/sword_basic.png")
	extra_tooltip = "" # "Generic flavourful description"
	aura_categories = [] # [auraCategories.common_aura]


#--functions called by aura_base.gd--
func setup_aura_stats() -> void:
	setup_basic_aura_data()
	#whatever the aura does
	additive_stat_dictionary[Stats.attack] = attack_increase

#--end of functions called by aura_base.gd--
