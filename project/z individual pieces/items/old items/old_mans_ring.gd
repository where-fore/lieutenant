extends Item

#whatever the item does, doesn't do anything until you do something with it
var my_attack:int = 1
var my_health:int = 10


func setup_basic_item_data() -> void:
	item_id = "old_mans_ring" # "generic_item"
	reward_name = "Master's Ring" # "Generic Item"
	reward_sprite = load("res://sprites/dual_ruby_ring.png")
	extra_tooltip = "" # "Generic flavourful description"
	reward_categories = {
	}

#--functions called by item_base.gd--
func setup_item_stats() -> void:
	setup_basic_item_data()
	
	#whatever the item does
	additive_stat_dictionary[Stats.attack] = my_attack
	additive_stat_dictionary[Stats.health] = my_health
