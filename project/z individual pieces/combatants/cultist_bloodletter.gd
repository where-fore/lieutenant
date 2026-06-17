extends Combatant

var health_cut_on_start:int = 75
	#consider changing the attack stat proportionally to this health cut, if changing it
var tithe_given:bool
var message:String = "Your life force drains from you."

func _init() -> void:
	combatant_name = "The Oblation" # "Generic Combatant"
	combatant_texture = load("res://sprites/half_cultist.png")
	extra_tooltip = "Extracts a brutal tithe of {val}% health immediately".format({"val":health_cut_on_start}) # "Generic flavourful description"
	combatant_categories = {
		Categories.enemy_rarity: Categories.Rarity.MYTHIC,
	}
	
	target_attribute = Stats.fortitude
	
	starting_stats[Stats.strength] = BalanceData.enemy_mythic_stat_budget / 2
	starting_stats[Stats.fortitude] = BalanceData.enemy_mythic_health_stat_budget

#called by Combatant
func on_start_combat() -> void:
	CombatLogEvents.custom_message.emit(message)
	
	for enemy:Combatant in possible_targets:
		var damage_to_deal:int = enemy.get_damaged_health() * health_cut_on_start/100
		enemy.take_damage(damage_to_deal, self)
