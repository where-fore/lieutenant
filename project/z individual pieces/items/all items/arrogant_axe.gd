extends Item

var my_attack:int = BalanceData.sword_damage

var attack_threshold:int = 60
var buff_aura:Aura
var buff_aura_name:String = "Monumental arrogance"

var super_attack:int = 20
var super_attack_multiplier:int = 100

func setup_basic_item_data() -> void:
	item_id = "arrogant_axe" # "generic_item"
	item_name = "Arrogant Axe" # "Generic Item"
	item_sprite = load("res://sprites/question.png")
	extra_tooltip = "Only hums with power if you have {val} or more attack".format({"val": attack_threshold}) # "Generic flavourful description"
	item_categories = {
		Categories.item_rarity : Categories.Rarity.MYTHIC,
	}
	

#--functions called by parents--
func setup_item_stats() -> void:
	setup_basic_item_data()
	additive_stat_dictionary[Stats.attack] = my_attack

func on_turn_start(source:Combatant) -> void:
	if buff_aura: clear_my_aura()
	if source.current_stats[Stats.attack] >= attack_threshold:
		apply_my_aura()

#--end of functions called by parents--

func apply_my_aura() -> void:
	buff_aura = Aura.new().create_aura(buff_aura_name, true)
	buff_aura.duration_type = AuraNames.DurationType.THIS_COMBAT
	
	buff_aura.additive_stat_dictionary[Stats.attack] = super_attack
	buff_aura.multiplicative_stat_dictionary[Stats.attack] = super_attack_multiplier
	
	AuraEvents.give_aura_to_player.emit(buff_aura)

func clear_my_aura() -> void:
	AuraEvents.remove_aura_from_player.emit(buff_aura)
	buff_aura = null
