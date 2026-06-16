extends Item

#basic setup
func setup_item_stats() -> void:
	reward_name = "Duelist's Tempo" # "Generic Item"
	reward_sprite = load("res://sprites/cross_swords.png")
	extra_tooltip = "Fills you with endurance as you trade blows,\nadding {amount} {stat} when damaged".format({"amount": my_stat_per_attack, "stat": my_stat}) # "Generic flavourful description"
	reward_categories = {
		Categories.item_rarity : Categories.Rarity.RARE,
	}
	
	#additive_stat_dictionary[Stats.agility] = BalanceData.rare_stat_budget / 3
	#additive_stat_dictionary[Stats.strength] = BalanceData.rare_stat_budget / 3
	#additive_stat_dictionary[Stats.fortitude] = BalanceData.rare_stat_budget / 3


#custom stuff
var my_stat:StringName = Stats.agility
var my_stat_per_attack:int = BalanceData.common_stat_budget * 3 / 2

var my_buff_aura:Aura

func on_combat_start() -> void:
	my_buff_aura = create_new_custom_aura()

func on_damage_taken(_amount_taken:int, source_of_damage:Combatant) -> void:
	if source_of_damage != parent_combatant:
		my_buff_aura.change_additive_aura(my_stat, my_stat_per_attack, true)
