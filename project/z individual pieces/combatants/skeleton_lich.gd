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

#you probably want to call this when instantiating it, to scale to something
func scale_stats(power:int) -> void:
	scaled_health = base_health * 2 + (power * base_health) #change 0 to whatever you want
	scaled_attack = base_attack * 2 + (power * base_attack)

#--functions called by combatant_data.gd--
func setup_stats() -> void:
	setup_basic_data()
	
	#whatever the combatant does

#called by Combatant
func on_start_combat() -> void:
	pass

func on_start_turn() -> void:
	pass

func on_after_attack() -> void:
	pass

func on_combat_end() -> void:
	pass
