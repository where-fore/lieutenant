extends Weapon
#class_name here

var attack_per_turn: int = 1
var tooltip: String = "Power surges by %s every attack" % attack_per_turn

func on_attack(_source:Combatant) -> void:
	self.get_aura().additive_dictionary[Stats.attack] += attack_per_turn
	

func _init() -> void:
	add_custom_tooltip(tooltip)
