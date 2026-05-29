extends Item

#whatever the item does, doesn't do anything until you do something with it
var my_damage:int = 1


func setup_basic_item_data() -> void:
	item_id = "rock" # "generic_item"
	reward_name = "Rock" # "Generic Item"
	reward_sprite = load("res://sprites/rock.png")
	extra_tooltip = "At least you feel prepared" # "Generic flavourful description"
	reward_categories = {
	}


#--functions called by item_base.gd--
func setup_item_stats() -> void:
	setup_basic_item_data()
	
	#whatever the item does
	additive_stat_dictionary[Stats.attack] = my_damage
