extends Weapon
class_name VampSword

var life_gain: int = 2
var tooltip: String = "Enjoy %s health on bloodshed" % life_gain

func on_attack(source:Combatant) -> void:
	#print_debug(source.baseData.name + " triggered special of " + item_name)
	
	#multiply by -1 to make it healing
	source.take_damage(life_gain * -1)
	pass

func _init() -> void:
	add_custom_tooltip(tooltip)
