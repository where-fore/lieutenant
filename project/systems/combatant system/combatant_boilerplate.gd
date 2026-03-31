extends CombatantData

func setup_basic_data() -> void:
	
	id = "" # "generic_enemy"
	name = "" # "Generic Combatant"
	texture = load("res://icon.svg")
	extra_tooltip = "" # "Generic flavourful description"
	

	base_health = 0
	base_attack = 0

#you probably want to call this when instantiating it, to scale to something
func scale_stats(power:int) -> void:
	scaled_health = base_health + (power * 0) #change to whatever math you want
	scaled_attack = base_attack + (power * 0)

#--functions called by combatant_data.gd--
func setup_stats() -> void:
	setup_basic_data()
	
	#whatever the combatant does
