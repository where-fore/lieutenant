extends Item

#basic setup
func setup_item_stats() -> void:
	reward_name = "Simmering Retribution" # "Generic Item"
	reward_sprite = load("res://sprites/question.png")
	extra_tooltip = "After taking {hit_count} hits of damage, your rage boils over, granting {value} {stat}".format({"hit_count": times_hit_required, "value": stat_gain_on_enrage, "stat": stat_to_gain}) # "Generic flavourful description"
	reward_categories = {
		Categories.item_rarity : Categories.Rarity.RARE,
	}
	
	additive_stat_dictionary[Stats.fortitude] = BalanceData.rare_stat_budget / 2
	multiplicative_stat_dictionary[Stats.fortitude] = BalanceData.rare_multiplicative_stat_budget / 2


#custom stuff
var times_hit_required:int = 4

var stat_to_gain:StringName = Stats.strength
var stat_gain_on_enrage:int = BalanceData.common_stat_budget * times_hit_required * 4
	# ie. give the stats you'd have by a regular item, multiplied by the number of turns you'd have benefitted from it already, multiplied by a value as a reward for going through the hoops

var times_hit_so_far:int

func on_damage_taken(_amount_taken:int, _source_of_damage:Combatant) -> void:
	times_hit_so_far += 1
	if times_hit_so_far == times_hit_required: apply_my_buff()

func apply_my_buff() -> void:
	var my_buff_aura:Aura = create_new_custom_aura()
	my_buff_aura.change_additive_aura(stat_to_gain, stat_gain_on_enrage, false)
