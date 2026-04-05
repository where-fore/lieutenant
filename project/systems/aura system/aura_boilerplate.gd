extends Aura

#whatever the aura does, doesn't do anything until you do something with it
var my_stat:int = 4

func setup_basic_aura_data() -> void:
	aura_id = "" # "generic_aura"
	aura_name = "" # "Generic aura"
	aura_sprite = null # load("res://icon.svg")
	extra_tooltip = "" # "Generic flavourful description"
	aura_categories = [] # [auraCategories.common_aura]

	duration_type = AuraNames.DurationType.PERMANENT

#--functions called by aura_base.gd--
func setup_aura_stats() -> void:
	setup_basic_aura_data()
	
	#whatever the aura does
	additive_stat_dictionary[Stats.attack] = my_stat

func on_attack(_source:Combatant) -> void:
	pass

func on_combat_start() -> void:
	pass

func on_combat_end() -> void:
	pass

#--end of functions called by aura_base.gd--
