extends Item


#basic setup
func setup_item_stats() -> void:
	reward_name = "Flank Slicer" # "Generic Item"
	reward_sprite = load("res://sprites/hook_sword.png")
	extra_tooltip = "Send your allies {amount} of your {stat},\nbolstering them and drawing enemy focus".format({"amount": stat_to_add_to_allies, "stat": stat_to_allies}) # "Generic flavourful description"
	reward_categories = {
		Categories.item_rarity : Categories.Rarity.RARE,
	}
	
	additive_stat_dictionary[Stats.agility] = BalanceData.basic_stat * 2


#custom stuff
var stat_to_allies:StringName = Stats.strength
var stat_to_add_to_allies:int = BalanceData.basic_stat

var debuff_on_me:Aura

func on_combat_start() -> void:
	debuff_on_me = create_new_custom_aura()
	
	for ally:Combatant in parent_combatant.allies:
		var aura_given:Aura = create_and_send_new_aura(ally)
		aura_given.change_additive_aura(stat_to_allies, stat_to_add_to_allies)
		debuff_on_me.change_additive_aura(stat_to_allies, -1 * stat_to_add_to_allies)
