extends CombatantData

var attack_per_turn:int = 3
var buff_aura_name:String = "Growing Impatience"
var buff_aura:Aura

func setup_basic_data() -> void:
	
	id = "skeleton_regent" # "generic_enemy"
	name = "Skeleton Regent" # "Generic Combatant"
	texture = load("res://sprites/enemy_boss.png")
	extra_tooltip = "A fallen regent with a fire growing in their eyes\nIncredibly powerful" # "Generic flavourful description"
	categories = {
		Categories.enemy_rarity : Categories.Rarity.MYTHIC,
	}
	
	

	base_health = BalanceData.enemy_base_health * 5
	base_attack = BalanceData.enemy_base_attack * 1

#--functions called by combatant_data.gd--
func setup_stats() -> void:
	setup_basic_data()
	
	#whatever the combatant does

#called by Combatant
func on_start_combat() -> void:
	buff_aura = Aura.new().create_aura(buff_aura_name, true)
	buff_aura.duration_type = AuraNames.DurationType.THIS_COMBAT
	AuraEvents.give_aura_to_enemy.emit(buff_aura)
	
	CombatLogEvents.custom_message.emit("A menacing foe approaches")

func on_after_attack() -> void:
	if not buff_aura.additive_stat_dictionary.has(Stats.attack):
		buff_aura.additive_stat_dictionary[Stats.attack] = 0
	buff_aura.additive_stat_dictionary[Stats.attack] += attack_per_turn
	buff_aura.update_aura()
	
	CombatLogEvents.custom_message.emit(self.name + "'s eyes flare brighter")
