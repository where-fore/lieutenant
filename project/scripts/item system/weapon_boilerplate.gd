extends Weapon
#class_name here

var custom_var: int = 4
var tooltip: String = "does %s cool stuff" % custom_var

func on_attack(_source:Combatant) -> void:
	#print_debug(_source.baseData.name + " triggered special of " + item_name)
	pass

func _init() -> void:
	add_custom_tooltip(tooltip)
