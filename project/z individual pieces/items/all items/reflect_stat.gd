extends Item

#basic setup
func setup_item_stats() -> void:
	reward_name = "Maille of Thorns" # "Generic Item"
	reward_sprite = load("res://sprites/question.png")
	extra_tooltip = "When taking damage, spines damage the attacker for {percent}% of your {stat}".format({"percent": reflect_percent_of_stat, "stat": reflect_stat}) # "Generic flavourful description"
	reward_categories = {
		Categories.item_rarity : Categories.Rarity.RARE,
	}
	
	additive_stat_dictionary[Stats.fortitude] = BalanceData.rare_stat_budget / 2
	multiplicative_stat_dictionary[Stats.fortitude] = BalanceData.rare_multiplicative_stat_budget / 2
	additive_stat_dictionary[Stats.attack] = BalanceData.basic_attack * -2


#custom stuff
var reflect_stat:StringName = Stats.fortitude
var reflect_percent_of_stat:int = 15 # 100 / Stats.agility_per_attack, if i wanted scaling to be identical to agility

func on_damage_taken(_amount_taken:int, source_of_damage:Combatant) -> void:
	var damage_to_deal:int = parent_combatant.current_stats.get(reflect_stat, 0) * reflect_percent_of_stat / 100
	source_of_damage.take_damage(damage_to_deal, parent_combatant)
