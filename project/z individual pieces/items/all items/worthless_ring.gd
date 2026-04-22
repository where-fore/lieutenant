extends Item

#whatever the item does, doesn't do anything until you do something with it
var my_health:int = 2


func setup_basic_item_data() -> void:
	item_id = "worthless_ring" # "generic_item"
	reward_name = "Pretty Ring" # "Generic Item"
	reward_sprite = load("res://sprites/ruby_ring.png")
	extra_tooltip = "" # "Generic flavourful description"
	item_categories = {
	}

#--functions called by item_base.gd--
func setup_item_stats() -> void:
	setup_basic_item_data()
	
	#whatever the item does
	additive_stat_dictionary[Stats.health] = my_health
