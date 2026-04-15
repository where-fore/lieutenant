extends Item

var my_attack:int = BalanceData.sword_damage
var my_health:int = BalanceData.shield_health

var attack_threshold:int = BalanceData.sword_damage * 10
var buff_aura:Aura
var buff_aura_name:String = "Monumental arrogance"

var super_attack_growth:int = 50

func setup_basic_item_data() -> void:
	item_id = "arrogant_axe" # "generic_item"
	item_name = "Arrogant Axe" # "Generic Item"
	item_sprite = load("res://sprites/double_sided_axe.png")
	extra_tooltip = "Only grants true power if you have {val} or more attack".format({"val": attack_threshold}) # "Generic flavourful description"
	extra_tooltip += "\nTrue power: attack grows by {val}% of itself every swing".format({"val":super_attack_growth})
	item_categories = {
		Categories.item_rarity : Categories.Rarity.MYTHIC,
	}
	

#--functions called by parents--
func setup_item_stats() -> void:
	setup_basic_item_data()
	additive_stat_dictionary[Stats.attack] = my_attack
	additive_stat_dictionary[Stats.health] = my_health

func on_turn_start(source:Combatant) -> void:
	if source.current_stats[Stats.attack] >= attack_threshold: #note i'm not checking pre-this buff, so it's almost impossible to drop off once it's active
		if not buff_aura:
			apply_my_aura()
		var attack_to_add:int = source.current_stats[Stats.attack] * super_attack_growth / 100
		buff_aura.additive_stat_dictionary[Stats.attack] += attack_to_add
		buff_aura.update_aura()
	else: 
		if buff_aura:
			clear_my_aura()

func on_combat_end() -> void:
	if buff_aura: clear_my_aura()
#--end of functions called by parents--

func apply_my_aura() -> void:
	buff_aura = Aura.new().create_aura(buff_aura_name, true)
	buff_aura.duration_type = AuraNames.DurationType.THIS_COMBAT
	
	buff_aura.additive_stat_dictionary[Stats.attack] = 0
	
	AuraEvents.give_aura_to_player.emit(buff_aura)

func clear_my_aura() -> void:
	AuraEvents.remove_aura_from_player.emit(buff_aura)
	buff_aura = null
