extends Item


func setup_item_stats() -> void:
	reward_name = "Warding Pike" # "Generic Item"
	reward_sprite = load("res://sprites/pike.png")
	extra_tooltip = "If you have {treshold} or more {threshold_stat}, gain {benefit}% {stat}".format({"treshold": stat_threshold, "threshold_stat": stat_to_check_for_threshold, "benefit": threshold_reward_value, "stat": threshold_reward_stat}) # "Generic flavourful description"
	reward_categories = {
		Categories.item_rarity : Categories.Rarity.RARE,
	}
	
	additive_stat_dictionary[Stats.strength] = BalanceData.basic_stat


#custom stuff
var stat_to_check_for_threshold:StringName = Stats.strength
var stat_threshold:int = BalanceData.basic_stat * 10
var threshold_reward_stat:StringName = Stats.health
var threshold_reward_value:int = 200

var my_threshold_mega_health:ThresholdBehaviour
var buff_aura:Aura
var buff_reward_name:String = "The Best Defence"

func on_equip() -> void:
	my_threshold_mega_health = create_new_threshold({stat_to_check_for_threshold: stat_threshold})
	my_threshold_mega_health.check_thresholds()

func threshold_state_changed(threshold:ThresholdBehaviour) -> void:
	if threshold == my_threshold_mega_health:
		if threshold.active:
			apply_my_aura()
		elif not threshold.active:
			clear_my_aura()

#--end of functions called by parents--

func apply_my_aura() -> void:
	buff_aura = create_new_custom_aura(AuraNames.DurationType.SPECIAL, buff_reward_name)
	buff_aura.change_multiplicative_aura(threshold_reward_stat, threshold_reward_value)

func clear_my_aura() -> void:
	if buff_aura:
		remove_from_custom_auras(buff_aura)
		buff_aura = null
