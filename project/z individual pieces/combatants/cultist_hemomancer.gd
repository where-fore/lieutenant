extends Combatant

var attack_percentage_to_steal:int = 50

var message:String = "Your power drains from you as the cultist's eyes alight with glee."
var buff_aura:Aura
var buff_reward_name:String = "The Thirst"
var debuff_aura:Aura
var debuff_reward_name:String = "The Thirst"

func _init() -> void:
	combatant_name = "The Thirst" # "Generic Combatant"
	combatant_texture = load("res://sprites/magic_cultist.png")
	extra_tooltip = "Siphons {val}% of enemies attack to their will, leaving enemies drained.".format({"val":attack_percentage_to_steal}) # "Generic flavourful description"
	combatant_categories = {
		Categories.enemy_rarity: Categories.Rarity.MYTHIC,
	}
	
	target_attribute = Stats.agility
	
	starting_stats[Stats.strength] = BalanceData.enemy_mythic_stat_budget
	starting_stats[Stats.fortitude] = BalanceData.enemy_mythic_health_stat_budget

#called by Combatant
func on_start_combat() -> void:
	create_auras()
	CombatLogEvents.custom_message.emit(message)

func create_auras() -> void:
	var total_attack_to_steal:int = 0
	
	for enemy:Combatant in possible_targets:
		var attack_to_steal:int = enemy.current_stats[Stats.attack] * attack_percentage_to_steal/100
		total_attack_to_steal += attack_to_steal
		
		debuff_aura = Aura.new().create_aura(debuff_reward_name, true)
		debuff_aura.duration_type = AuraNames.DurationType.THIS_COMBAT
		debuff_aura.multiplicative_stat_dictionary[Stats.attack] = -1 * attack_percentage_to_steal
		enemy.apply_aura_or_item(debuff_aura)
		
		#note applying a 50% additive debuff is much more impactful if you have a lower multiplier. going from 350% -> 300% attack is much less impactful than 100% -> 50%
		#but the cultist gains much more attack if you have a higher atack value
		#overall ideally it incentivizes non-attack-stacking
	
	buff_aura = Aura.new().create_aura(buff_reward_name, true)
	buff_aura.duration_type = AuraNames.DurationType.THIS_COMBAT
	buff_aura.additive_stat_dictionary[Stats.attack] = total_attack_to_steal
	apply_aura_or_item(buff_aura)
