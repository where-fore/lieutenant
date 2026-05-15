extends Item

#whatever the item does, doesn't do anything until you do something with it
var my_stat_multi:int = BalanceData.basic_stat_scaling
var my_stat:StringName = Stats.health


func setup_basic_item_data() -> void:
	reward_name = "Iron Buckler" # "Generic Item"
	reward_sprite = load("res://sprites/small_buckler.png")
	extra_tooltip = "" # "Generic flavourful description"
	item_categories = {
		Categories.item_rarity : Categories.Rarity.COMMON,
	}

#--functions called by item_base.gd--
func setup_item_stats() -> void:
	setup_basic_item_data()
	
	#whatever the item does
	multiplicative_stat_dictionary[my_stat] = my_stat_multi
