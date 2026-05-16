extends Item

#whatever the item does, doesn't do anything until you do something with it
var my_stat:int = BalanceData.basic_stat
var threshold_per_hit:int = BalanceData.basic_stat * 5
var percent_stat_to_deal:int = 50
var stat_to_check:StringName = Stats.dexterity

func setup_basic_item_data() -> void:
	reward_name = "Moon Kris" # "Generic Item"
	reward_sprite = load("res://sprites/items/wavy_dagger.png")
	extra_tooltip = "After attacking, for every {threshold} {stat},\ndeal damage equal to {percent}% of your {stat}".format({"threshold": threshold_per_hit, "stat": stat_to_check,  "percent": percent_stat_to_deal}) # "Generic flavourful description"
	item_categories = {
		Categories.item_rarity : Categories.Rarity.MYTHIC,
	}

#--functions called by item_base.gd--
func setup_item_stats() -> void:
	setup_basic_item_data()
	
	#whatever the item does
	additive_stat_dictionary[Stats.dexterity] = my_stat

func on_attack(source:Combatant, target:Combatant) -> void:
	var multiples_of_threshold:int = source.current_stats[stat_to_check] / threshold_per_hit
	var damage_to_deal:int = source.current_stats[stat_to_check] * percent_stat_to_deal / 100
	while multiples_of_threshold > 0:
		target.take_damage(damage_to_deal)
		multiples_of_threshold -= 1
