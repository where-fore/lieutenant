extends Weapon
#class_name here

var attack_per_turn: int = 5
var tooltip: String = "Power surges by %s every attack" % attack_per_turn

func on_attack(_source:Combatant) -> void:
	var my_aura:Aura = self.get_aura()
	my_aura.additive_dictionary[Stats.attack] += attack_per_turn
	my_aura.update_aura()
	

func _init() -> void:
	add_custom_tooltip(tooltip)
