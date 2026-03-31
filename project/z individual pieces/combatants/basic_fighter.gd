extends CombatantData

func setup_basic_data() -> void:
	
	id = "basic_player_fighter" # "generic_enemy"
	name = "Our Hero" # "Generic Combatant"
	texture = load("res://sprites/player.png")
	extra_tooltip = "" # "Generic flavourful description"
	

	base_health = BalanceData.player_base_health
	base_attack = BalanceData.player_base_attack

#you probably want to call this when instantiating it, to scale to something
func scale_stats(power:int) -> void:
	scaled_health = base_health + (power * 0) #change 0 to whatever you want
	scaled_attack = base_attack + (power * 0)

#--functions called by combatant_data.gd--
func setup_stats() -> void:
	setup_basic_data()
	
	#whatever the combatant does
