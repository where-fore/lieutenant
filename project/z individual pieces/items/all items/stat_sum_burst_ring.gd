extends Item


#basic setup
func setup_item_stats() -> void:
	reward_name = "Prismatic Ring" # "Generic Item"
	reward_sprite = load("res://sprites/ruby_ring.png")
	extra_tooltip = "On your turn {turns}, fire a blast for {percent}% of each of your attributes".format({"turns": activate_on_turn, "percent": percent_of_stats_to_deal}) # "Generic flavourful description"
	reward_categories = {
		Categories.item_rarity : Categories.Rarity.RARE,
	}
	
	for stat:StringName in Stats.attributes:
		multiplicative_stat_dictionary[stat] = BalanceData.common_multiplicative_stat_budget * 2 / 5 #magic number


#custom stuff
var percent_of_stats_to_deal:int = 10
var activate_on_turn:int = 5

var has_activated:bool
var turn_counter:int
var activation_message:String = "Polychromatic energy bursts from the ring of {parent_combatant}."

func on_combat_start() -> void:
	has_activated = false
	turn_counter = 0

func on_turn_start(_source:Combatant) -> void:
	turn_counter += 1

func on_attack(_source:Combatant, target:Combatant) -> void:
	if turn_counter >= activate_on_turn and not has_activated:
		
		CombatLogEvents.custom_message.emit(activation_message.format({"parent_combatant": parent_combatant.combatant_name}))
		
		target.take_damage(calc_stat_sum_damage())
		
		has_activated = true

func calc_stat_sum_damage() -> int:
	var damage_to_deal:int = 0
	for attribute:StringName in Stats.attributes:
		damage_to_deal += parent_combatant.current_stats[attribute] * percent_of_stats_to_deal / 100
	
	return damage_to_deal
