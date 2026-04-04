extends Combatant

func _init() -> void:
	combatant_id = "skeleton_berserker" # "generic_enemy"
	combatant_name = "Skeleton Berserker" # "Generic Combatant"
	combatant_texture = load("res://sprites/enemy_berserker.png")
	extra_tooltip = "A quick and lethal monster" # "Generic flavourful description"
	combatant_categories = {
		Categories.enemy_rarity : Categories.Rarity.RARE,
	}
	
	base_health = BalanceData.enemy_base_health / 2
	base_attack = BalanceData.enemy_base_attack * 3
