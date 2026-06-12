extends Item

#basic setup
func setup_basic_item_data() -> void:
	reward_name = "Giant Slayer" # "Generic Item"
	reward_sprite = load("res://sprites/single_spiked_axe.png")
	extra_tooltip = "Deal an extra {val}% of victims maximum health".format({"val": max_hp_percent_damage}) # "Generic flavourful description"
	reward_categories = {
		Categories.item_rarity : Categories.Rarity.RARE,
	}
	
	additive_stat_dictionary[Stats.strength] = BalanceData.rare_stat_budget / 2
	additive_stat_dictionary[Stats.agility] = BalanceData.rare_stat_budget / 2


#custom stuff
var max_hp_percent_damage:int = 6
func setup_item_stats() -> void:
	setup_basic_item_data()
	

func on_attack(_source:Combatant, target:Combatant) -> void:
	var damage_to_deal:int = target.current_stats[Stats.health] * max_hp_percent_damage / 100
	target.take_damage(damage_to_deal, parent_combatant)
