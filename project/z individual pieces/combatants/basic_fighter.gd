extends Combatant

func _init() -> void:
	combatant_name = "Enil" # "Generic Combatant"
	combatant_texture = load("res://sprites/knight.png")
	extra_tooltip = "" # "Generic flavourful description"
	
	starting_stats[Stats.strength] = BalanceData.player_base_strength
	starting_stats[Stats.dexterity] = BalanceData.player_base_dexterity
	starting_stats[Stats.intelligence] = BalanceData.player_base_intelligence
