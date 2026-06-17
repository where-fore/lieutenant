extends Item

#basic setup
func setup_item_stats() -> void:
	reward_name = "Moon Kris" # "Generic Item"
	reward_sprite = load("res://sprites/items/wavy_dagger.png")
	extra_tooltip = "After attacking, for every {threshold} {stat},\ndeal damage equal to {percent}% of your {stat}".format({"threshold": threshold_per_hit, "stat": stat_to_check,  "percent": percent_stat_to_deal}) # "Generic flavourful description"
	reward_categories = {
		Categories.item_rarity : Categories.Rarity.RARE,
	}
	
	#additive_stat_dictionary[Stats.agility] = BalanceData.rare_stat_budget


#custom stuff
var stat_to_check:StringName = Stats.agility
var threshold_per_hit:int = BalanceData.common_stat_budget * 5
var percent_of_stat_already_used_for_attack:int = int((1.0 / Stats.agility_per_attack) * 100)
var percent_stat_to_deal:int = percent_of_stat_already_used_for_attack / 2

func on_attack(source:Combatant, target:Combatant) -> void:
	var multiples_of_threshold:int = source.current_stats[stat_to_check] / threshold_per_hit
		#note this is int division so it truncates, as i want
	var damage_to_deal:int = source.current_stats[stat_to_check] * percent_stat_to_deal / 100
	while multiples_of_threshold > 0:
		target.take_damage(damage_to_deal, parent_combatant)
		multiples_of_threshold -= 1
