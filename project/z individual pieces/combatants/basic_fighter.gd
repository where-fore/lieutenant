extends Combatant

func _init() -> void:
	combatant_name = "Enil" # "Generic Combatant"
	combatant_texture = load("res://sprites/portraits/man_1.png")
	extra_tooltip = "" # "Generic flavourful description"
	
	starting_stats[Stats.strength] = 0
	starting_stats[Stats.agility] = 0
	starting_stats[Stats.mind] = 0
	starting_stats[Stats.fortitude] = 0
	
	#starting_items = [Database.get_reward_by_id("necklace_of_bloodbath")]
