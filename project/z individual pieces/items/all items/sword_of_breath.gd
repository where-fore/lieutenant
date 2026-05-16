extends Item

#whatever the item does, doesn't do anything until you do something with it
var my_stat_add:int = BalanceData.basic_stat
var my_stat:StringName = Stats.dexterity
var my_stat_per_attack:int = BalanceData.basic_stat


func setup_basic_item_data() -> void:
	reward_name = "Lungfiller" # "Generic Item"
	reward_sprite = load("res://sprites/items/nature_sword.png")
	extra_tooltip = "Fills you with endurance as you fight,\nadding {amount} {stat} per turn".format({"amount": my_stat_per_attack, "stat": my_stat}) # "Generic flavourful description"
	item_categories = {
		Categories.item_rarity : Categories.Rarity.RARE,
	}

#--functions called by item_base.gd--
func setup_item_stats() -> void:
	setup_basic_item_data()
	
	#whatever the item does
	additive_stat_dictionary[my_stat] = my_stat_add
	
	push_warning(reward_name," script not ready")
	#something about creating a this-combat buff, and scaling it per attack
	#like crashing waves
