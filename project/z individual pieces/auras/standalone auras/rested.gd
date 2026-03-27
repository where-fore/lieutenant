extends Aura

#whatever the aura does, doesn't do anything until you do something with it
var health_increase:int = BalanceData.rest_hp

func setup_basic_aura_data() -> void:
	aura_id = "rested" # "generic_aura"
	aura_name = "Well Rested" # "Generic aura"
	aura_sprite = load("res://sprites/heart_purple.png")
	extra_tooltip = "" # "Generic flavourful description"
	aura_categories = [] # [auraCategories.common_aura]


#--functions called by aura_base.gd--
func setup_aura_stats() -> void:
	setup_basic_aura_data()
	#whatever the aura does
	additive_stat_dictionary[Stats.health] = health_increase

func on_attack(_source:Combatant) -> void:
	pass

func on_combat_start() -> void:
	pass

func on_combat_end() -> void:
	pass

#--end of functions called by aura_base.gd--
