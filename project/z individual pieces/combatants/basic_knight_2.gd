extends Combatant

func _init() -> void:
	combatant_name = "Aribald" # "Generic Combatant"
	combatant_texture = load("res://sprites/knight.png")
	extra_tooltip = "" # "Generic flavourful description"
	
	starting_stats[Stats.strength] = BalanceData.player_base_strength
	starting_stats[Stats.agility] = BalanceData.player_base_agility / 2
	starting_stats[Stats.fortitude] = BalanceData.player_base_fortitude

	starting_items = [Database.get_reward_by_id("enrage_sword")]
