extends CombatantData

func setup_basic_data() -> void:
	
	id = "basic_skeleton" # "generic_enemy"
	name = "Skeleton Warrior" # "Generic Combatant"
	texture = load("res://sprites/enemy_skull.png")
	extra_tooltip = "An enemy of balanced strength" # "Generic flavourful description"
	categories = {
		Categories.enemy_rarity : Categories.Rarity.COMMON,
	}

	base_health = BalanceData.enemy_base_health
	base_attack = BalanceData.enemy_base_attack

#you probably want to call this when instantiating it, to scale to something
func scale_stats(power:int) -> void:
	scaled_health = base_health + (power * base_health)
	scaled_attack = base_attack + (power * base_attack)

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
