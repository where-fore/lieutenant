extends Aura

#whatever the aura does, doesn't do anything until you do something with it
static var attack_per_turn:int = BalanceData.sword_damage * 3/2
var base_attack:int = 0
var combat_log_message:String = "The tide ebbs."

func setup_basic_aura_data() -> void:
	aura_id = "crashing_waves_aura" # "generic_aura"
	aura_name = "Surging Waves" # "Generic aura"
	aura_sprite = load("res://sprites/hook_sword.png")
	extra_tooltip = "" # "Generic flavourful description"
	aura_categories = [] # [auraCategories.common_aura]

	duration_type = AuraNames.DurationType.THIS_COMBAT
	base_duration = 0

#--functions called by aura_base.gd--
func setup_aura_stats() -> void:
	setup_basic_aura_data()
	
	#whatever the aura does
	additive_stat_dictionary[Stats.attack] = base_attack

func on_attack(_source:Combatant) -> void:
	additive_stat_dictionary[Stats.attack] += attack_per_turn
	update_aura()
	CombatLogEvents.custom_message.emit(combat_log_message)

func on_combat_start() -> void:
	pass

func on_combat_end() -> void:
	pass

#--end of functions called by aura_base.gd--
