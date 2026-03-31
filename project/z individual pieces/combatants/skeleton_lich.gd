extends CombatantData

func setup_basic_data() -> void:
	
	id = "skeleton_lich" # "generic_enemy"
	name = "Skeleton Lich" # "Generic Combatant"
	texture = load("res://sprites/enemy_lich.png")
	extra_tooltip = "A hardy pile of bones" # "Generic flavourful description"
	categories = {
		Categories.enemy_rarity : Categories.Rarity.COMMON,
	}
	

	base_health = BalanceData.enemy_base_health * 3
	base_attack = BalanceData.enemy_base_attack * 1/2

#--functions called by combatant_data.gd--
func setup_stats() -> void:
	setup_basic_data()
	
	#whatever the combatant does
