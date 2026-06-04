extends Item

#basic setup
func setup_item_stats() -> void:
	reward_name = "Brute's Arrogance" # "Generic Item"
	reward_sprite = load("res://sprites/double_sided_axe.png")
	extra_tooltip = "While above {health}% health, bolsters your {stat} by {percent_gain}%".format({"health": my_health_threshold_percent, "percent_gain": my_threshold_attack_multi, "stat": my_threshold_stat}) # "Generic flavourful description"
	reward_categories = {
		Categories.item_rarity : Categories.Rarity.RARE,
	}
	
	additive_stat_dictionary[Stats.strength] = BalanceData.rare_stat_budget


#custom stuff
var my_health_threshold_percent:int = 65
var my_threshold_stat:StringName = Stats.attack
var my_threshold_attack_multi:int = BalanceData.common_multiplicative_stat_budget * 4
var my_threshold:ThresholdBehaviour
var my_aura:Aura


func on_equip() -> void:
	my_threshold = create_new_threshold({}, my_health_threshold_percent)
	my_threshold.check_thresholds()

func threshold_state_changed(threshold:ThresholdBehaviour) -> void:
	if threshold == my_threshold:
		if threshold.active:
			my_aura = create_new_custom_aura(AuraNames.DurationType.SPECIAL)
			my_aura.change_multiplicative_aura(my_threshold_stat, my_threshold_attack_multi)
		if not threshold.active:
			remove_from_custom_auras(my_aura)
