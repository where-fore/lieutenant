extends Item

#whatever the item does, doesn't do anything until you do something with it
var my_stat_add:int = BalanceData.basic_stat
var my_stat:StringName = Stats.strength
var my_stat_per_turn:StringName = Stats.attack
var my_stat_per_attack:int = BalanceData.basic_attack

var my_buff_aura:Aura

func setup_basic_item_data() -> void:
	reward_name = "Iron Hacker" # "Generic Item"
	reward_sprite = load("res://sprites/single_sided_axe.png")
	extra_tooltip = "Smash through armor and bone successively, adding {amount} {stat} per turn".format({"amount": my_stat_per_attack, "stat": my_stat_per_turn}) # "Generic flavourful description"
	item_categories = {
		Categories.item_rarity : Categories.Rarity.RARE,
	}

#--functions called by item_base.gd--
func setup_item_stats() -> void:
	setup_basic_item_data()
	
	#whatever the item does
	additive_stat_dictionary[my_stat] = my_stat_add

func on_combat_start() -> void:
	my_buff_aura = create_new_custom_aura(AuraNames.DurationType.THIS_COMBAT)

func on_turn_start(_source:Combatant) -> void:
	my_buff_aura.change_additive_aura(my_stat_per_turn, my_stat_per_attack, true)
