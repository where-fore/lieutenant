extends Combatant

func _init() -> void:
	combatant_name = "Arlaeus" # "Generic Combatant"
	combatant_texture = load("res://sprites/knight.png")
	extra_tooltip = "" # "Generic flavourful description"
	
	starting_stats[Stats.strength] = BalanceData.player_base_strength * 3 / 2
	starting_stats[Stats.agility] = BalanceData.player_base_agility * 1 / 2
	starting_stats[Stats.fortitude] = BalanceData.player_base_fortitude

	starting_auras = [Database.get_reward_by_id("flower_red")]
