extends WeaponData
#class_name here

var attack_per_turn: int = 1
var tooltip: String = "Power surges by %s every attack" % attack_per_turn

func on_attack(_source:Combatant) -> void:
	#print_debug(_source.baseData.name + " triggered special of " + item_name)
	pass

func _init() -> void:
	add_custom_tooltip(tooltip)
