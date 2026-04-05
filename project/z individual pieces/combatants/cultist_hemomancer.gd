extends Combatant

var attack_percentage_to_steal:int = 50
var message:String = "Your power drains from you as the cultist's eyes alight with glee."
var buff_aura:Aura
var buff_aura_name:String = "The Thirst"
var debuff_aura:Aura
var debuff_aura_name:String = "The Thirst"

func _init() -> void:
	combatant_id = "cultist_hemomancer" # "generic_enemy"
	combatant_name = "The Thirst" # "Generic Combatant"
	combatant_texture = load("res://sprites/question.png")
	extra_tooltip = "Siphons {val}% of enemies attack to their will".format({"val":attack_percentage_to_steal}) # "Generic flavourful description"
	combatant_categories = {
		Categories.enemy_rarity: Categories.Rarity.MYTHIC,
	}
	
	base_health = BalanceData.enemy_base_health * 2
	base_attack = BalanceData.enemy_base_attack * 3/2

#called by Combatant
func on_start_combat() -> void:
	create_auras()
	CombatLogEvents.custom_message.emit(message)

#called by Combatant
func create_auras() -> void:
	var attack_to_steal:int = current_target.current_stats[Stats.attack] * attack_percentage_to_steal/100
	
	buff_aura = Aura.new().create_aura(buff_aura_name, true)
	buff_aura.duration_type = AuraNames.DurationType.THIS_COMBAT
	buff_aura.additive_stat_dictionary[Stats.attack] = attack_to_steal
	AuraEvents.give_aura_to_enemy.emit(buff_aura)
	
	debuff_aura = Aura.new().create_aura(debuff_aura_name, true)
	debuff_aura.duration_type = AuraNames.DurationType.THIS_COMBAT
	debuff_aura.additive_stat_dictionary[Stats.attack] = -1 * attack_to_steal
	debuff_aura.visible = false #this stops it from displays text, for now. hacky
	AuraEvents.give_aura_to_player.emit(debuff_aura)
