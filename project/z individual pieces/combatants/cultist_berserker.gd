extends CombatantData

var turns_dormant:int = 2
var current_turns_elapsed:int
var dormant:bool
var post_buff_attack:int
var buff_aura_name:String = "Bloodthirsty"
var buff_message:String = "The cultist's pupils dilate as they enter a fury."

func setup_basic_data() -> void:
	
	id = "cultist_berserker" # "generic_enemy"
	name = "The Vein" # "Generic Combatant"
	texture = load("res://sprites/question.png")
	extra_tooltip = "Highly ravenous and lethal once tasting blood" # "Generic flavourful description"
	categories = {
		Categories.enemy_rarity : Categories.Rarity.RARE,
	}
	

	base_health = BalanceData.enemy_base_health
	base_attack = 0
	post_buff_attack = BalanceData.enemy_base_attack * 4

#--functions called by combatant_data.gd--
func setup_stats() -> void:
	setup_basic_data()
	
	#whatever the combatant does

#called by Combatant
func on_start_combat() -> void:
	current_turns_elapsed = 0
	dormant = true

func on_start_turn() -> void:
	if dormant and current_turns_elapsed >= turns_dormant:
		dormant = false
		buff_attack()

func on_end_turn() -> void:
	current_turns_elapsed += 1

func buff_attack() -> void:
	var buff_aura:Aura = Aura.new().create_aura(buff_aura_name, true)
	buff_aura.duration_type = AuraNames.DurationType.THIS_COMBAT
	buff_aura.additive_stat_dictionary[Stats.attack] = post_buff_attack
	AuraEvents.give_aura_to_enemy.emit(buff_aura)
	CombatLogEvents.custom_message.emit(buff_message)
