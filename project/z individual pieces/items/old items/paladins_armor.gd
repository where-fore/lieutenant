extends Item

#whatever the item does, doesn't do anything until you do something with it
var health_multi:int = 200

func setup_basic_item_data() -> void:
	item_id = "paladins_armor" # "generic_item"
	reward_name = "Fallen Paladin's Armor" # "Generic Item"
	reward_sprite = load("res://sprites/armor.png")
	extra_tooltip = "" # "Generic flavourful description"
	reward_categories = {
		Categories.item_rarity : Categories.Rarity.RARE,
	}


#--functions called by item_base.gd--
func setup_item_stats() -> void:
	setup_basic_item_data()
	
	#whatever the item does
	multiplicative_stat_dictionary[Stats.health] = health_multi
