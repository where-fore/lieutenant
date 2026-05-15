extends Item

#whatever the item does, doesn't do anything until you do something with it
var my_stat_add:int = BalanceData.basic_stat * 2
var my_stat:StringName = Stats.dexterity

var stat_to_allies:StringName = Stats.strength
var stat_to_add_to_allies:int = BalanceData.basic_stat * 2


func setup_basic_item_data() -> void:
	reward_name = "Flank Slicer" # "Generic Item"
	reward_sprite = load("res://sprites/hook_sword.png")
	extra_tooltip = "Bolsters your allies for {amount} {stat}, feinting focus to them".format({"amount": stat_to_add_to_allies, "stat": stat_to_allies}) # "Generic flavourful description"
	item_categories = {
		Categories.item_rarity : Categories.Rarity.RARE,
	}

#--functions called by item_base.gd--
func setup_item_stats() -> void:
	setup_basic_item_data()
	
	#whatever the item does
	additive_stat_dictionary[my_stat] = my_stat_add

#something about creating a this-combat buff, and giving it to your allies
