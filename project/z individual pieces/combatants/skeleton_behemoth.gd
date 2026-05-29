extends Combatant

var turns_to_double_stats:int = 6
	#note this isn't literally doubling in 6 turns, due to truncation for players intuitions sake

var attack_per_turn:int
var buff_reward_name:String = "Growing Impatience"
var buff_aura:Aura

func _init() -> void:
	combatant_name = "The Marrow" # "Generic Combatant"
	combatant_texture = load("res://sprites/enemy_shattered.png")
	extra_tooltip = "Monstrously tough and imposingly large\nAttacks more savagely as blood is shed" # "Generic flavourful description"
	combatant_categories = {
		Categories.enemy_rarity: Categories.Rarity.MYTHIC,
	}
	
	starting_stats[Stats.strength] = BalanceData.enemy_mythic_stat_budget
	starting_stats[Stats.fortitude] = BalanceData.enemy_mythic_stat_budget
	attack_per_turn = starting_stats[Stats.strength] / Stats.strength_per_attack / turns_to_double_stats
	attack_per_turn = max(1, attack_per_turn)

#called by Combatant
func on_start_combat() -> void:
	buff_aura = Aura.new().create_aura(buff_reward_name, true)
	buff_aura.duration_type = AuraNames.DurationType.THIS_COMBAT
	apply_aura_or_item(buff_aura)

func on_after_attack() -> void:
	if not buff_aura.additive_stat_dictionary.has(Stats.attack):
		buff_aura.additive_stat_dictionary[Stats.attack] = 0
	buff_aura.change_additive_aura(Stats.attack, attack_per_turn, true)
	
	CombatLogEvents.custom_message.emit(combatant_name + " roars")
