extends Item

var my_attack:int = BalanceData.sword_damage * 2

var attack_threshold:int = BalanceData.sword_damage * 7
var buff_aura:Aura
var buff_aura_name:String = "The Best Defence"

var super_health_multiplier:int = 200

func setup_basic_item_data() -> void:
	item_id = "warding_pike" # "generic_item"
	item_name = "Warding Pike" # "Generic Item"
	item_sprite = load("res://sprites/question.png")
	extra_tooltip = "If you have {treshold} or more attack, gain {benefit}% health".format({"treshold": attack_threshold, "benefit": super_health_multiplier}) # "Generic flavourful description"
	item_categories = {
		Categories.item_rarity : Categories.Rarity.RARE,
	}
	

#--functions called by parents--
func setup_item_stats() -> void:
	setup_basic_item_data()
	additive_stat_dictionary[Stats.attack] = my_attack

func on_turn_start(source:Combatant) -> void:
	if source.current_stats[Stats.attack] >= attack_threshold:
		if not buff_aura:
			apply_my_aura()
	else: 
		if buff_aura:
			clear_my_aura()

#--end of functions called by parents--

func apply_my_aura() -> void:
	buff_aura = Aura.new().create_aura(buff_aura_name, true)
	buff_aura.duration_type = AuraNames.DurationType.THIS_COMBAT
	
	buff_aura.multiplicative_stat_dictionary[Stats.health] = super_health_multiplier
	
	AuraEvents.give_aura_to_player.emit(buff_aura)

func clear_my_aura() -> void:
	AuraEvents.remove_aura_from_player.emit(buff_aura)
	buff_aura = null
