extends Item

#basic setup
func setup_item_stats() -> void:
	reward_name = "Iron Hacker" # "Generic Item"
	reward_sprite = load("res://sprites/single_sided_axe.png")
	extra_tooltip = "Smash through armor and bone successively, adding {amount} {stat} per turn".format({"amount": my_stat_per_attack, "stat": my_stat_per_turn}) # "Generic flavourful description"
	reward_categories = {
		Categories.item_rarity : Categories.Rarity.RARE,
	}
	
	#additive_stat_dictionary[Stats.strength] = BalanceData.rare_stat_budget

#custom stuff
var my_stat_per_turn:StringName = Stats.attack
var my_stat_per_attack:int = BalanceData.basic_attack

var my_buff_aura:Aura

func on_combat_start() -> void:
	my_buff_aura = create_new_custom_aura()

func on_turn_start(_source:Combatant) -> void:
	my_buff_aura.change_additive_aura(my_stat_per_turn, my_stat_per_attack, true)
