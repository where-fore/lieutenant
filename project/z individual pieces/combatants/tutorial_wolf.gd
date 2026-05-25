extends Combatant

func _init() -> void:
	combatant_name = "Hollow-hide Wolf" # "Generic Combatant"
	combatant_texture = load("res://sprites/wolf.png")
	extra_tooltip = "A wild canine with little strength left" # "Generic flavourful description"
	combatant_categories = {
	}

	starting_stats[Stats.strength] = BalanceData.enemy_tutorial_easy_stat_budget / 2
	starting_stats[Stats.dexterity] = BalanceData.enemy_tutorial_easy_stat_budget / 2
