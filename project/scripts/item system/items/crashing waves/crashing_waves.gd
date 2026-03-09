extends Weapon
#class_name here

var attack_per_turn:int = 5
var tooltip:String = "Power surges by %s every attack" % attack_per_turn
var combat_log_message:String = "The tide ebbs."

func on_attack(_source:Combatant) -> void:
	var my_aura:Aura = self.get_custom_aura()
	if not my_aura.additive_dictionary.has(Stats.attack):
		my_aura.additive_dictionary[Stats.attack] = 0
	my_aura.additive_dictionary[Stats.attack] += attack_per_turn
	my_aura.update_aura()
	CombatLogEvents.custom_message.emit(combat_log_message)

func on_combat_end() -> void:
	var my_aura:Aura = self.get_custom_aura()
	my_aura.additive_dictionary[Stats.attack] = 0
	my_aura.update_aura()
