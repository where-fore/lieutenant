extends CombatantData

var health_cut_on_start:int = 50
var tithe_given:bool

func setup_basic_data() -> void:
	
	id = "cultist_bloodletter" # "generic_enemy"
	name = "The Oblation" # "Generic Combatant"
	texture = load("res://sprites/question.png")
	extra_tooltip = "Extracts a brutal tithe of {val}% health immediately".format({"val":health_cut_on_start}) # "Generic flavourful description"
	categories = {
		Categories.enemy_rarity : Categories.Rarity.RARE,
	}
	

	base_health = BalanceData.enemy_base_health
	base_attack = BalanceData.enemy_base_attack

#--functions called by combatant_data.gd--
func setup_stats() -> void:
	setup_basic_data()
	
	#whatever the combatant does

#called by Combatant
func on_start_combat() -> void:
	pass
	#current_target... hmmm.... template doesn't know who it's attacking
