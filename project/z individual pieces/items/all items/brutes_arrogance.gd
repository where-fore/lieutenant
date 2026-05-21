extends Item

#whatever the item does, doesn't do anything until you do something with it
var my_stat_add:int = BalanceData.basic_stat
var my_stat:StringName = Stats.strength

var my_health_threshold_percent:int = 65
var my_threshold_stat:StringName = Stats.attack
var my_threshold_attack_multi:int = BalanceData.basic_stat_scaling * 4


func setup_basic_item_data() -> void:
	reward_name = "Brute's Arrogance" # "Generic Item"
	reward_sprite = load("res://sprites/double_sided_axe.png")
	extra_tooltip = "While above {health}% health, bolsters your {stat} by {percent_gain}%".format({"health": my_health_threshold_percent, "percent_gain": my_threshold_attack_multi, "stat": my_threshold_stat}) # "Generic flavourful description"
	item_categories = {
		Categories.item_rarity : Categories.Rarity.MYTHIC,
	}

#--functions called by item_base.gd--
func setup_item_stats() -> void:
	setup_basic_item_data()
	
	#whatever the item does
	additive_stat_dictionary[my_stat] = my_stat_add
	#push_warning(reward_name," script not ready")
	#something about a threshold buff, and checking it against hp (on damage? on turn start?)
	#like old arrogant axe
