extends Item

var turns_active:int = 4
var turns_passed:int = 0
var shield_active:bool = false
var shield_strength:int = 999
var shield_active_message:String = "A powerful arcane shield covers your body."
var shield_falling_message:String = "Your arcane shield dissipates."

func setup_basic_item_data() -> void:
	reward_name = "Necklace of Second Blood" # "Generic Item"
	reward_sprite = load("res://sprites/ruby_gorget.png")
	extra_tooltip = "Begin combat with a powerful but temporary shield for {shield_value},\nthat falls after you take {turns} turns.".format({"turns": turns_active, "shield_value": shield_strength}) # "Generic flavourful description"
	reward_categories = {
	}

#--functions called by parents--
func setup_item_stats() -> void:
	setup_basic_item_data()

func on_combat_start() -> void:
	parent_combatant.shield += shield_strength
	CombatLogEvents.custom_message.emit(shield_active_message)
	shield_active = true
	turns_passed = 0

func on_turn_end(_source:Combatant) -> void:
	turns_passed += 1
	if turns_passed >= turns_active:
		if shield_active: remove_shield()

func on_combat_end() -> void:
	if shield_active: remove_shield()

func remove_shield() -> void:
	parent_combatant.shield -= shield_strength
	CombatLogEvents.custom_message.emit(shield_falling_message)
	shield_active = false

#--end of functions called by parents--
