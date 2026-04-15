extends Item

var turn_counter:int
var turns_active:int = 5
var buff_aura:Aura
var buff_aura_name:String = "Safe Haven"
var shield:int = BalanceData.shield_health * 30

func setup_basic_item_data() -> void:
	item_id = "necklace_of_bloodbath" # "generic_item"
	item_name = "Necklace of Bloodbath" # "Generic Item"
	item_sprite = load("res://sprites/ruby_gorget.png")
	extra_tooltip = "For you first {turns} turns, bathe in as much blood as you desire. Pay for it later.".format({"turns": turns_active,}) # "Generic flavourful description"
	item_categories = {
		Categories.item_rarity : Categories.Rarity.RARE,
	}
	

#--functions called by parents--
func setup_item_stats() -> void:
	setup_basic_item_data()

func on_combat_start() -> void:
	turn_counter = 0
	apply_my_aura()

func on_turn_start(_source:Combatant) -> void:
	turn_counter += 1
	if turn_counter > turns_active and buff_aura:
		clear_my_aura()

#--end of functions called by parents--

func apply_my_aura() -> void:
	buff_aura = Aura.new().create_aura(buff_aura_name, true)
	buff_aura.duration_type = AuraNames.DurationType.THIS_COMBAT
	
	buff_aura.additive_stat_dictionary[Stats.health] = shield
	
	AuraEvents.give_aura_to_player.emit(buff_aura)

func clear_my_aura() -> void:
	AuraEvents.remove_aura_from_player.emit(buff_aura)
	buff_aura = null
