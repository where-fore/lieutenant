extends Combatant

func _init() -> void:
	combatant_id = "tutorial_wolf" # "generic_enemy"
	combatant_name = "Hollow-hide Wolf" # "Generic Combatant"
	combatant_texture = load("res://sprites/wolf.png")
	extra_tooltip = "A wild canine with little strength left" # "Generic flavourful description"
	combatant_categories = {
	}

	starting_stats[Stats.health] = BalanceData.tutorial_base_health
	starting_stats[Stats.attack] = BalanceData.tutorial_base_attack
