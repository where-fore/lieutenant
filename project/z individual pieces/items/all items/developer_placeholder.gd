extends Item

func setup_basic_item_data() -> void:
	reward_name = "Developer Placeholder" # "Generic Item"
	reward_sprite = load("res://sprites/question.png")
	extra_tooltip = "Oops! You probably shouldn't be seeing this" # "Generic flavourful description"
	item_categories = {
	}

#--functions called by item_base.gd--
func setup_item_stats() -> void:
	setup_basic_item_data()
