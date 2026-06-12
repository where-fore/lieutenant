extends Combatant

func _init() -> void:
	combatant_name = "Skeleton Berserker" # "Generic Combatant"
	combatant_texture = load("res://sprites/enemy_berserker.png")
	extra_tooltip = "A quick and lethal monster" # "Generic flavourful description"
	combatant_categories = {
		Categories.enemy_rarity: Categories.Rarity.RARE,
	}
	
	target_attribute = Stats.agility
	
	starting_stats[Stats.agility] = BalanceData.enemy_rare_stat_budget
	starting_stats[Stats.fortitude] = BalanceData.enemy_rare_health_stat_budget
