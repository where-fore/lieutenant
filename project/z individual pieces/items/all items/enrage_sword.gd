extends Item

#basic item seutp
func setup_item_stats() -> void:
	reward_name = "Holy Revenger" # "Generic Item"
	reward_sprite = load("res://sprites/sword_basic.png")
	extra_tooltip = "When your first ally falls in combat, scream into a fury,\ngaining {amount} {stat}".format({"amount": my_enrage_stat_bonus, "stat": my_enrage_stat}) # "Generic flavourful description"
	reward_categories = {
		Categories.item_rarity : Categories.Rarity.RARE,
	}
	
	additive_stat_dictionary[Stats.strength] = BalanceData.basic_stat


#custom stuff
var my_buff_aura:Aura

var my_enrage_stat:StringName = Stats.attack
var my_enrage_stat_bonus:int = BalanceData.basic_attack * 4

func on_other_combatant_dying(newly_dead_combatant:Combatant) -> void:
	if not my_buff_aura and newly_dead_combatant in parent_combatant.allies:
		my_buff_aura = create_new_custom_aura()
		my_buff_aura.change_additive_aura(my_enrage_stat, my_enrage_stat_bonus)
