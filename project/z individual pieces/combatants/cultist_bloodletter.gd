extends Combatant

var health_cut_on_start:int = 75
var tithe_given:bool
var message:String = "Your life force drains from you."

func _init() -> void:
	combatant_id = "cultist_bloodletter" # "generic_enemy"
	combatant_name = "The Oblation" # "Generic Combatant"
	combatant_texture = load("res://sprites/half_cultist.png")
	extra_tooltip = "Extracts a brutal tithe of {val}% health immediately".format({"val":health_cut_on_start}) # "Generic flavourful description"
	combatant_categories = {
		Categories.enemy_rarity: Categories.Rarity.MYTHIC,
	}
	
	base_health = BalanceData.enemy_base_health * 3/2
	base_attack = (BalanceData.enemy_base_attack * 3/2 * (100-health_cut_on_start)) /100

#called by Combatant
func on_start_combat() -> void:
	CombatLogEvents.custom_message.emit(message)
	
	var damage_to_deal:int = current_target.get_damaged_health() * health_cut_on_start/100
	for enemy:Combatant in possible_targets:
		enemy.take_damage(damage_to_deal)
