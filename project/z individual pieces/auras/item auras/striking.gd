extends Aura

#whatever the aura does, doesn't do anything until you do something with it
var multiplier:int = 100

func setup_basic_aura_data() -> void:
	aura_id = "striking" # "generic_aura"
	aura_name = "Striking" # "Generic aura"
	aura_sprite = load("res://sprites/sword.png")
	extra_tooltip = "" # "Generic flavourful description"
	aura_categories = [] # [auraCategories.common_aura]

	duration_type = AuraNames.DurationType.TURNS
	base_duration = 3

#--functions called by aura_base.gd--
func setup_aura_stats() -> void:
	setup_basic_aura_data()
	
	#whatever the aura does
	multiplicative_stat_dictionary[Stats.attack] = multiplier

func on_attack(_source:Combatant) -> void:
	pass

func on_combat_start() -> void:
	pass

func on_combat_end() -> void:
	pass

#--end of functions called by aura_base.gd--
