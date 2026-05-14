extends Combatant

func _init() -> void:
	combatant_id = "skeleton_berserker" # "generic_enemy"
	combatant_name = "Skeleton Berserker" # "Generic Combatant"
	combatant_texture = load("res://sprites/enemy_berserker.png")
	extra_tooltip = "A quick and lethal monster" # "Generic flavourful description"
	combatant_categories = {
		Categories.enemy_rarity: Categories.Rarity.RARE,
	}
	
	starting_stats[Stats.dexterity] = BalanceData.enemy_rare_stat_budget
