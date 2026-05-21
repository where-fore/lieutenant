extends Item

var my_attack:int = BalanceData.basic_attack * 4

var buff_aura:Aura
var buff_reward_name:String = "The Best Defence"

var stat_to_check_for_threshold:StringName = Stats.attack
var stat_threshold:int = BalanceData.basic_attack * 5
var super_health_multiplier:int = 200

var my_threshold_mega_health:ThresholdBehaviour

func setup_basic_item_data() -> void:
	reward_name = "Warding Pike" # "Generic Item"
	reward_sprite = load("res://sprites/pike.png")
	extra_tooltip = "If you have {treshold} or more attack, gain {benefit}% health".format({"treshold": stat_threshold, "benefit": super_health_multiplier}) # "Generic flavourful description"
	item_categories = {
		Categories.item_rarity : Categories.Rarity.RARE,
	}
	

#--functions called by parents--
func setup_item_stats() -> void:
	setup_basic_item_data()
	additive_stat_dictionary[Stats.attack] = my_attack

func on_equip() -> void:
	my_threshold_mega_health = create_new_threshold({stat_to_check_for_threshold: stat_threshold})

func threshold_state_changed(threshold:ThresholdBehaviour) -> void:
	if threshold == my_threshold_mega_health:
		if threshold.active:
			apply_my_aura()
		elif not threshold.active:
			clear_my_aura()

#--end of functions called by parents--

func apply_my_aura() -> void:
	buff_aura = Aura.new().create_aura(buff_reward_name, true)
	buff_aura.duration_type = AuraNames.DurationType.SPECIAL
	buff_aura.reward_sprite = reward_sprite
	
	buff_aura.multiplicative_stat_dictionary[Stats.health] = super_health_multiplier
	
	add_to_custom_auras(buff_aura)

func clear_my_aura() -> void:
	if buff_aura:
		remove_from_custom_auras(buff_aura)
		buff_aura = null
