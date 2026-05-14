extends Combatant

func _init() -> void:
	combatant_id = "basic_player_rogue" # "generic_enemy"
	combatant_name = "Jon the Rogue" # "Generic Combatant"
	combatant_texture = load("res://sprites/portraits/man_1.png")
	extra_tooltip = "" # "Generic flavourful description"
	
	starting_stats[Stats.strength] = BalanceData.player_base_strength / 2
	starting_stats[Stats.dexterity] = BalanceData.player_base_dexterity * 2
