extends Item

#basic item seutp
func setup_item_stats() -> void:
	reward_name = "Lungfiller" # "Generic Item"
	reward_sprite = load("res://sprites/items/nature_sword.png")
	extra_tooltip = "Fills you with endurance as you fight,\nadding {amount} {stat} per turn".format({"amount": my_stat_per_attack, "stat": my_stat}) # "Generic flavourful description"
	reward_categories = {
		Categories.item_rarity : Categories.Rarity.RARE,
	}
	
	#additive_stat_dictionary[Stats.agility] = BalanceData.rare_stat_budget


#custom stuff
var my_buff_aura:Aura

var my_stat:StringName = Stats.agility
var my_stat_per_attack:int = BalanceData.common_stat_budget / 2

func on_combat_start() -> void:
	my_buff_aura = create_new_custom_aura()

func on_turn_start(_source:Combatant) -> void:
	my_buff_aura.change_additive_aura(my_stat, my_stat_per_attack, true)
