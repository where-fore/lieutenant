extends CombatantData

func setup_basic_data() -> void:
	
	id = "skeleton_berserker" # "generic_enemy"
	name = "Skeleton Berserker" # "Generic Combatant"
	texture = load("res://sprites/enemy_berserker.png")
	extra_tooltip = "" # "Generic flavourful description"
	categories = [] # [Categories.weak_enemy]

	base_health = 2500
	base_attack = 9000

#you probably want to call this when instantiating it, to scale to something
func scale_stats(power:int) -> void:
	scaled_health = base_health + (power * 0) #change 0 to whatever you want
	scaled_attack = base_health + (power * 0)

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
