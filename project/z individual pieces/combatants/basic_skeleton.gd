extends Combatant

func _init() -> void:
	combatant_name = "Skeleton Warrior" # "Generic Combatant"
	combatant_texture = load("res://sprites/enemy_skull.png")
	extra_tooltip = "An enemy of balanced strength" # "Generic flavourful description"
	combatant_categories = {
		Categories.enemy_rarity: Categories.Rarity.COMMON,
	}

	starting_stats[Stats.strength] = BalanceData.enemy_normal_stat_budget
