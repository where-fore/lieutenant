extends Item

#whatever the item does, doesn't do anything until you do something with it
var my_stats:Array[StringName] = [
	Stats.strength,
	Stats.dexterity,
	Stats.intelligence,
]
var my_stat_bonus:int = BalanceData.basic_stat


func setup_basic_item_data() -> void:
	reward_name = "Necklace of the Vitruvian" # "Generic Item"
	reward_sprite = load("res://sprites/adorned_ruby_necklace.png")
	extra_tooltip = "" # "Generic flavourful description"
	item_categories = {
		Categories.item_rarity : Categories.Rarity.RARE,
	}

#--functions called by item_base.gd--
func setup_item_stats() -> void:
	setup_basic_item_data()
	
	for stat:StringName in my_stats:
		additive_stat_dictionary[stat] = my_stat_bonus
