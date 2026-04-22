extends Item

#whatever the item does, doesn't do anything until you do something with it
var my_damage:int = BalanceData.sword_damage
var my_multiplier:int = 50


func setup_basic_item_data() -> void:
	item_id = "iron_sword" # "generic_item"
	reward_name = "Iron Sword" # "Generic Item"
	reward_sprite = load("res://sprites/sword.png")
	extra_tooltip = "" # "Generic flavourful description"
	item_categories = {
		Categories.item_rarity : Categories.Rarity.COMMON,
	}

#--functions called by item_base.gd--
func setup_item_stats() -> void:
	setup_basic_item_data()
	
	#whatever the item does
	additive_stat_dictionary[Stats.attack] = my_damage
	multiplicative_stat_dictionary[Stats.attack] = my_multiplier
