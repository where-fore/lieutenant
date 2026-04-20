extends Combatant

func _init() -> void:
	combatant_id = "basic_player_rogue" # "generic_enemy"
	combatant_name = "Jon the Rogue" # "Generic Combatant"
	combatant_texture = load("res://sprites/player.png")
	extra_tooltip = "" # "Generic flavourful description"
	
	base_health = BalanceData.player_base_health * 2/3
	base_attack = BalanceData.player_base_attack * 2

#you probably want to call this when instantiating it, to scale to something
func scale_stats(power:int) -> void:
	scaled_health = base_health + (power * 0) #change 0 to whatever you want
	scaled_attack = base_attack + (power * 0)
