extends Combatant

func _init() -> void:
	combatant_id = "basic_player_fighter" # "generic_enemy"
	combatant_name = "John the Fighter" # "Generic Combatant"
	combatant_texture = load("res://sprites/knight.png")
	extra_tooltip = "" # "Generic flavourful description"
	
	starting_stats[Stats.health] = BalanceData.player_base_health
	starting_stats[Stats.attack] = BalanceData.player_base_attack
	starting_stats[Stats.strength] = 10
