extends Item

#whatever the item does, doesn't do anything until you do something with it
var my_stat_add:int = BalanceData.basic_stat
var my_stat:StringName = Stats.strength

var starting_hp:int = BalanceData.player_base_strength / Stats.strength_per_health + BalanceData.player_base_dexterity / Stats.dexterity_per_health
var my_health_threshold:int = starting_hp * 20
var my_threshold_attack_factor:int = 25


func setup_basic_item_data() -> void:
	reward_name = "Mountainslide" # "Generic Item"
	reward_sprite = load("res://sprites/single_spiked_axe.png")
	extra_tooltip = "If you are mighty as a mountain with more than {health_threshold} health,\nsmash for an extra {percent} of your {stat} when attacking".format({"health_threshold": my_health_threshold,"percent": my_threshold_attack_factor, "stat": my_stat}) # "Generic flavourful description"
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

func on_attack(source:Combatant, target:Combatant) -> void:
	
	#if threshold met...
	var damage_to_deal:int = source.current_stats[my_stat] * my_threshold_attack_factor / 100
	target.take_damage(damage_to_deal)
