extends Item

#basic setup
func setup_item_stats() -> void:
	reward_name = "Maille of Quills" # "Generic Item"
	reward_sprite = load("res://sprites/armor_dark.png")
	extra_tooltip = "When taking damage, spines damage the attacker for {damage}".format({"damage": damage_reflect_value}) # "Generic flavourful description"
	reward_categories = {
		Categories.item_rarity : Categories.Rarity.RARE,
	}
	
	additive_stat_dictionary[Stats.fortitude] = BalanceData.rare_stat_budget / 2
	multiplicative_stat_dictionary[Stats.fortitude] = BalanceData.rare_multiplicative_stat_budget / 2
	additive_stat_dictionary[Stats.attack] = BalanceData.basic_attack * -2


#custom stuff
var damage_reflect_value:int = BalanceData.basic_attack * 4
func on_damage_taken(_amount_taken:int, source_of_damage:Combatant) -> void:
	if source_of_damage != parent_combatant:
		source_of_damage.take_damage(damage_reflect_value, parent_combatant)
