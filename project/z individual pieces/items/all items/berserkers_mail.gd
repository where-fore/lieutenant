extends Item

#basic setup
func setup_item_stats() -> void:
	reward_name = "Berserker's Fury" # "Generic Item"
	reward_sprite = load("res://sprites/dual_ruby_ring.png")
	extra_tooltip = "When taking damage, gain {value} {stat}".format({"value": stat_gain_per_hit, "stat": stat_to_gain}) # "Generic flavourful description"
	reward_categories = {
		Categories.item_rarity : Categories.Rarity.RARE,
	}
	
	#additive_stat_dictionary[Stats.fortitude] = BalanceData.common_stat_budget
	multiplicative_stat_dictionary[Stats.fortitude] = BalanceData.rare_multiplicative_stat_budget


#custom stuff
var stat_to_gain:StringName = Stats.attack
var stat_gain_per_hit:int = BalanceData.basic_attack

var my_buff_aura:Aura

func on_combat_start() -> void:
	my_buff_aura = create_new_custom_aura()

func on_damage_taken(_amount_taken:int, source_of_damage:Combatant) -> void:
	if source_of_damage != parent_combatant:
		my_buff_aura.change_additive_aura(stat_to_gain, stat_gain_per_hit, true)
