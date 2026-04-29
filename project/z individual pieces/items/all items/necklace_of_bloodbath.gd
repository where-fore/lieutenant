extends Item

var turns_active:int = 4
var buff_aura:Aura
var buff_reward_name:String = "Safe Haven"
var shield:int = BalanceData.shield_health * 30

func setup_basic_item_data() -> void:
	item_id = "necklace_of_bloodbath" # "generic_item"
	reward_name = "Necklace of Bloodbath" # "Generic Item"
	reward_sprite = load("res://sprites/ruby_gorget.png")
	extra_tooltip = "For you first {turns} turns, bathe in as much blood as you desire. Pay for it later.".format({"turns": turns_active,}) # "Generic flavourful description"
	item_categories = {
		Categories.item_rarity : Categories.Rarity.RARE,
	}

#--functions called by parents--
func setup_item_stats() -> void:
	setup_basic_item_data()

func on_combat_start() -> void:
	apply_my_aura()

#--end of functions called by parents--

func apply_my_aura() -> void:
	buff_aura = Aura.new().create_aura(buff_reward_name)
	buff_aura.duration_type = AuraNames.DurationType.TURNS
	buff_aura.base_duration = turns_active
	buff_aura.reward_sprite = reward_sprite
	buff_aura.additive_stat_dictionary[Stats.health] = shield
	
	add_to_custom_auras(buff_aura)
