extends WeaponData
class_name VampSword

func on_attack(source:Combatant) -> void:
	print_debug(source.baseData.name + " triggered special of " + item_name)
	source.take_damage(-10)
	pass
