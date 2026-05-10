extends Combatant

func _init() -> void:
	combatant_id = "basic_player_rogue" # "generic_enemy"
	combatant_name = "Jon the Rogue" # "Generic Combatant"
	combatant_texture = load("res://sprites/portraits/man_1.png")
	extra_tooltip = "" # "Generic flavourful description"
	
	starting_stats[Stats.health] = BalanceData.player_base_health * 2/3
	starting_stats[Stats.attack] = BalanceData.player_base_attack * 2
	starting_stats[Stats.dexterity] = 10
