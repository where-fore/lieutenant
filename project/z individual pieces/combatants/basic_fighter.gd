extends Combatant

func _init() -> void:
	combatant_name = "Enil" # "Generic Combatant"
	combatant_texture = load("res://sprites/portraits/man_1.png")
	extra_tooltip = "" # "Generic flavourful description"
	
	starting_stats[Stats.strength] = BalanceData.player_base_strength
	starting_stats[Stats.agility] = BalanceData.player_base_agility
	starting_stats[Stats.mind] = BalanceData.player_base_mind
	starting_stats[Stats.fortitude] = BalanceData.player_base_fortitude
	
	#starting_items = [Database.get_reward_by_id("stat_sum_burst_ring")]
