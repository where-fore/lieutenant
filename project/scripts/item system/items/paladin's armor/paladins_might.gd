extends Aura

func setup_aura_stats() -> void:
	additive_dictionary[Stats.health] = +5
	additive_dictionary[Stats.attack] = +2
	multiplicative_dictionary[Stats.health] = +1
