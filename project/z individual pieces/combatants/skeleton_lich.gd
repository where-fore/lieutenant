extends Combatant

func _init() -> void:
	combatant_id = "skeleton_lich" # "generic_enemy"
	combatant_name = "Skeleton Lich" # "Generic Combatant"
	combatant_texture = load("res://sprites/enemy_lich.png")
	extra_tooltip = "A hardy pile of bones" # "Generic flavourful description"
	combatant_categories = {
		Categories.enemy_rarity: Categories.Rarity.RARE,
	}
	
	starting_stats[Stats.health] = BalanceData.enemy_base_health * 3
	starting_stats[Stats.attack] = BalanceData.enemy_base_attack * 1/2
