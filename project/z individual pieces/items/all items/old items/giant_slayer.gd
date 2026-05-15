extends Item

var current_hp_percent_damage:int = 8
var my_attack:int = BalanceData.sword_damage * 3

func setup_basic_item_data() -> void:
	item_id = "giant_slayer" # "generic_item"
	reward_name = "Giant Slayer" # "Generic Item"
	reward_sprite = load("res://sprites/single_spiked_axe.png")
	extra_tooltip = "Deal an extra {val}% of victims current health".format({"val": current_hp_percent_damage}) # "Generic flavourful description"
	item_categories = {
		Categories.item_rarity : Categories.Rarity.RARE,
	}


#--functions called by item_base.gd--
func setup_item_stats() -> void:
	setup_basic_item_data()
	
	additive_stat_dictionary[Stats.attack] = my_attack

func on_attack(_source:Combatant, target:Combatant) -> void:
	var damage_to_deal:int = max(0, target.get_damaged_health()) * current_hp_percent_damage / 100
	damage_to_deal = max(1, damage_to_deal)
	target.take_damage(damage_to_deal)
