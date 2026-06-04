extends Item

#currently defunct - if i want a temporary invuln thing, i don't want to hack it with health or shield
#since things scale off health or shield
#i should do some sort of damage taken multi, or a status, or something more specific

var turns_active:int = 5
var buff_aura:Aura
var buff_reward_name:String = "Safe Haven"

func setup_basic_item_data() -> void:
	item_id = "necklace_of_bloodbath" # "generic_item"
	reward_name = "Necklace of Bloodbath" # "Generic Item"
	reward_sprite = load("res://sprites/ruby_gorget.png")
	extra_tooltip = "For your first {turns} turns, shrug damage off with a powerful shield.".format({"turns": turns_active,}) # "Generic flavourful description"
	reward_categories = {
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
	
	add_to_custom_auras(buff_aura)
