extends Item

var has_activated:bool
var turn_counter:int
var activate_on_turn:int = 5
var activation_message:String = "You bellow a terrifying bear's roar, and swipe feverishly."

#var base_health:int = BalanceData.shield_health /2
var base_health_multiplier:int = 150

func setup_basic_item_data() -> void:
	item_id = "bears_defence" # "generic_item"
	item_name = "Defence of the Bear" # "Generic Item"
	item_sprite = load("res://sprites/cross_necklace.png")
	extra_tooltip = "On your turn {turns}, violently swipe for your current health total".format({"turns": activate_on_turn,}) # "Generic flavourful description"
	item_categories = {
		Categories.item_rarity : Categories.Rarity.MYTHIC,
	}
	

#--functions called by parents--
func setup_item_stats() -> void:
	setup_basic_item_data()
	
	#additive_stat_dictionary[Stats.health] = base_health
	multiplicative_stat_dictionary[Stats.health] = base_health_multiplier

func on_combat_start() -> void:
	has_activated = false
	turn_counter = 0

func on_turn_start(_source:Combatant) -> void:
	turn_counter += 1

func on_attack(source:Combatant, target:Combatant) -> void:
	if turn_counter >= activate_on_turn and not has_activated:
		CombatLogEvents.custom_message.emit(activation_message)
		
		var damage:int = source.get_damaged_health()
		target.take_damage(damage)
		has_activated = true

#--end of functions called by parents--
