extends Item

var health_per_day:int = BalanceData.player_base_hp_per_day

#basic setup
func setup_item_stats() -> void:
	reward_name = "Mother's Locket" # "Generic Item"
	reward_sprite = load("res://sprites/mothers_necklace.png")
	extra_tooltip = "Keepsake from home, filled with vital energy.\nCan bring intact bodies back from death.\nRaises Max Health by {amount} every sunrise.".format({"amount": health_per_day,}) # "Generic flavourful description"
	reward_categories = {
	}
	
	additive_stat_dictionary[Stats.strength] = BalanceData.player_base_strength
	additive_stat_dictionary[Stats.agility] = BalanceData.player_base_agility
	additive_stat_dictionary[Stats.mind] = BalanceData.player_base_mind
	additive_stat_dictionary[Stats.fortitude] = BalanceData.player_base_fortitude


#custom stuff
func on_new_day() -> void:
	if not additive_stat_dictionary.get(Stats.health):
		additive_stat_dictionary[Stats.health] = health_per_day
	else: additive_stat_dictionary[Stats.health] += health_per_day
	
	_runtime_aura.change_additive_aura(Stats.health, health_per_day, true)
