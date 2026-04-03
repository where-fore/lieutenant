extends Combatant

func _init() -> void:
	combatant_id = "basic_skeleton" # "generic_enemy"
	combatant_name = "Skeleton Warrior" # "Generic Combatant"
	combatant_texture = load("res://sprites/enemy_skull.png")
	extra_tooltip = "An enemy of balanced strength" # "Generic flavourful description"
	combatant_categories = {
		Categories.enemy_rarity : Categories.Rarity.COMMON,
	}

	base_health = BalanceData.enemy_base_health
	base_attack = BalanceData.enemy_base_attack
