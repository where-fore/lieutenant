extends CombatantData

func setup_basic_data() -> void:
	
	id = "skeleton_berserker" # "generic_enemy"
	name = "Skeleton Berserker" # "Generic Combatant"
	texture = load("res://sprites/enemy_berserker.png")
	extra_tooltip = "A quick and lethal monster" # "Generic flavourful description"
	categories = {
		Categories.enemy_rarity : Categories.Rarity.COMMON,
	}
	

	base_health = BalanceData.enemy_base_health / 2
	base_attack = BalanceData.enemy_base_attack * 3

#--functions called by combatant_data.gd--
func setup_stats() -> void:
	setup_basic_data()
	
	#whatever the combatant does
