extends Combatant

func _init() -> void:
	combatant_name = "Developer Target Dummy" # "Generic Combatant"
	combatant_texture = load("res://sprites/question.png")
	extra_tooltip = "Test em up!" # "Generic flavourful description"
	combatant_categories = {
	}

	starting_stats[Stats.health] = BalanceData.basic_health * 100
	starting_stats[Stats.attack] = 0
	starting_stats[Stats.mind] = 20
