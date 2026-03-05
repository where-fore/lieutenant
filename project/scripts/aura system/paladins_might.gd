extends Aura

func _init() -> void:
	display_dictionary["name"] = "Paladin's Might"
	additive_dictionary[Stats.health] = +5
	additive_dictionary[Stats.attack] = +2
	multiplicative_dictionary[Stats.health] = +1
	pass
