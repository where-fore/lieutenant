extends Item


#basic setup
func setup_item_stats() -> void:
	reward_name = "Defence of the Bear" # "Generic Item"
	reward_sprite = load("res://sprites/cross_necklace.png")
	extra_tooltip = "On your turn {turns}, violently swipe for {percent}% of your maximum health".format({"turns": activate_on_turn, "percent": percent_of_hp_to_deal}) # "Generic flavourful description"
	reward_categories = {
		Categories.item_rarity : Categories.Rarity.RARE,
	}
	
	multiplicative_stat_dictionary[Stats.fortitude] = BalanceData.rare_multiplicative_stat_budget / 2
	multiplicative_stat_dictionary[Stats.strength] = BalanceData.rare_multiplicative_stat_budget / 2


#custom stuff
var percent_of_hp_to_deal:int = 100
var activate_on_turn:int = 4
var activation_message:String = "{parent_combatant} bellows a terrifying bear's roar, and swipes feverishly."

var has_activated:bool
var turn_counter:int

func on_combat_start() -> void:
	has_activated = false
	turn_counter = 0

func on_turn_start(_source:Combatant) -> void:
	turn_counter += 1

func on_attack(_source:Combatant, target:Combatant) -> void:
	if turn_counter >= activate_on_turn and not has_activated:
		
		CombatLogEvents.custom_message.emit(activation_message.format({"parent_combatant": parent_combatant.combatant_name}))
		
		var damage:int = parent_combatant.current_stats[Stats.health]
			#note this is max health, could do current with source.get_damaged_health()
		target.take_damage(damage)
		has_activated = true
