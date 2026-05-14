extends Combatant

var stats_to_buff:Array[StringName] = [
	Stats.strength,
	Stats.dexterity,
	Stats.intelligence,
]
var turns_to_double_stats:int = 4
	#note this isn't literally doubling in 6 turns, due to truncation for players intuitions sake

var stat_growth_per_turn:int
var buff_reward_name:String = "Growing Impatience"
var buff_aura:Aura

func _init() -> void:
	combatant_id = "skeleton_regent" # "generic_enemy"
	combatant_name = "Skeleton Regent" # "Generic Combatant"
	combatant_texture = load("res://sprites/enemy_boss.png")
	extra_tooltip = "A fallen regent with a fire growing in their eyes\nGrows in power through combat" # "Generic flavourful description"
	combatant_categories = {
	}
	
	starting_stats[Stats.strength] = BalanceData.enemy_boss_stat_budget * 1/3
	starting_stats[Stats.dexterity] = BalanceData.enemy_boss_stat_budget * 1/3
	starting_stats[Stats.intelligence] = BalanceData.enemy_boss_stat_budget * 1/3
	
	stat_growth_per_turn = BalanceData.enemy_boss_stat_budget / stats_to_buff.size() / turns_to_double_stats
	stat_growth_per_turn = max(1, stat_growth_per_turn)

#called by Combatant
func on_start_combat() -> void:
	buff_aura = Aura.new().create_aura(buff_reward_name, true)
	buff_aura.duration_type = AuraNames.DurationType.THIS_COMBAT
	apply_aura_or_item(buff_aura)
	
	CombatLogEvents.custom_message.emit("A menacing foe approaches")

func on_after_attack() -> void:
	for stat:StringName in stats_to_buff:
		if not buff_aura.additive_stat_dictionary.has(stat):
			buff_aura.additive_stat_dictionary[stat] = 0
		buff_aura.additive_stat_dictionary[stat] += stat_growth_per_turn
		
	buff_aura.update_aura()
	
	CombatLogEvents.custom_message.emit(self.name + "'s eyes flare brighter")
