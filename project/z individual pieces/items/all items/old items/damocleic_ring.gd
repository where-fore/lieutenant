extends Item

var turn_counter:int
var activate_every_turns:int = 2
var damage_on_activation:int = BalanceData.sword_damage * 5
var activation_message:String = "The time has come, your ring glows brightly."


func setup_basic_item_data() -> void:
	item_id = "damocleic_ring" # "generic_item"
	reward_name = "Damocleic Ring" # "Generic Item"
	reward_sprite = load("res://sprites/gaudy_ruby_ring.png")
	extra_tooltip = "Every {turns} turns, explode in a brief fury for {damage} damage".format({"turns": activate_every_turns, "damage": damage_on_activation}) # "Generic flavourful description"
	item_categories = {
		Categories.item_rarity : Categories.Rarity.COMMON,
	}
	

#--functions called by parents--
func setup_item_stats() -> void:
	setup_basic_item_data()

func on_combat_start() -> void:
	turn_counter = 0

func on_turn_start(_source:Combatant) -> void:
	turn_counter += 1

func on_attack(_source:Combatant, target:Combatant) -> void:
	if turn_counter % activate_every_turns == 0:
		CombatLogEvents.custom_message.emit(activation_message)
		
		var damage:int = damage_on_activation
		target.take_damage(damage)

#--end of functions called by parents--
