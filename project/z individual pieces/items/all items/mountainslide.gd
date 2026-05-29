extends Item

#basic setup
func setup_item_stats() -> void:
	reward_name = "Mountainslide" # "Generic Item"
	reward_sprite = load("res://sprites/single_spiked_axe.png")
	extra_tooltip = "If you are mighty as a mountain with more than {health_threshold} {threshold_stat},\nsmash for an extra {percent}% of your {stat} when attacking".format({"health_threshold": my_health_threshold, "threshold_stat": my_threshold_stat ,"percent": my_threshold_attack_factor, "stat": my_threshold_attack_stat}) # "Generic flavourful description"
	reward_categories = {
		Categories.item_rarity : Categories.Rarity.MYTHIC,
	}
	
	additive_stat_dictionary[Stats.strength] = BalanceData.basic_stat * 2


#custom stuff
var starting_hp:int = BalanceData.player_base_strength / Stats.strength_per_health + BalanceData.player_base_agility / Stats.agility_per_health
var my_health_threshold:int = starting_hp * 20
var my_threshold_stat:StringName = Stats.health

var my_threshold_attack_factor:int = 25
var my_threshold_attack_stat:StringName = Stats.strength

var my_threshold:ThresholdBehaviour

func on_equip() -> void:
	my_threshold = create_new_threshold({my_threshold_stat: my_health_threshold})
	my_threshold.check_thresholds()

func on_attack(source:Combatant, target:Combatant) -> void:
	if my_threshold.active:
		var damage_to_deal:int = source.current_stats[my_threshold_attack_stat] * my_threshold_attack_factor / 100
		target.take_damage(damage_to_deal)
