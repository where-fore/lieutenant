extends Item

#basic item seutp
func setup_item_stats() -> void:
	reward_name = "Lungfiller" # "Generic Item"
	reward_sprite = load("res://sprites/items/nature_sword.png")
	extra_tooltip = "Fills you with endurance as you fight,\nadding {amount} {stat} per turn".format({"amount": my_stat_per_attack, "stat": my_stat}) # "Generic flavourful description"
	item_categories = {
		Categories.item_rarity : Categories.Rarity.RARE,
	}
	
	additive_stat_dictionary[Stats.dexterity] = BalanceData.basic_stat


#custom stuff
var my_buff_aura:Aura

var my_stat:StringName = Stats.dexterity
var my_stat_per_attack:int = BalanceData.basic_stat

func on_combat_start() -> void:
	my_buff_aura = create_new_custom_aura(AuraNames.DurationType.THIS_COMBAT)

func on_turn_start(_source:Combatant) -> void:
	my_buff_aura.change_additive_aura(my_stat, my_stat_per_attack, true)
