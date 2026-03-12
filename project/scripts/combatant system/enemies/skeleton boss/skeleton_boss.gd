extends Combatant

var attack_per_turn:int = 1

var buff_aura_name:String = "Growing Impatience"
var buff_aura:Aura

func on_start_combat() -> void:
	buff_aura = Aura.new()
	buff_aura.create_aura(buff_aura_name, true)
	buff_aura.duration_type = AuraNames.DurationType.THIS_COMBAT
	AuraEvents.give_aura_to_enemy.emit(buff_aura)
	
	CombatLogEvents.custom_message.emit("A menacing foe approaches")

func on_after_attack() -> void:
	if not buff_aura.additive_dictionary.has(Stats.attack):
		buff_aura.additive_dictionary[Stats.attack] = 0
	buff_aura.additive_dictionary[Stats.attack] += attack_per_turn
	buff_aura.update_aura()
	
	CombatLogEvents.custom_message.emit(self.baseData.name + "'s eyes flare brighter")
