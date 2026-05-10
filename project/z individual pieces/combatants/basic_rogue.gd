extends Combatant

func _init() -> void:
	combatant_id = "basic_player_rogue" # "generic_enemy"
	combatant_name = "Jon the Rogue" # "Generic Combatant"
	combatant_texture = load("res://sprites/portraits/man_1.png")
	extra_tooltip = "" # "Generic flavourful description"
	
	starting_stats[Stats.dexterity] = 20
	starting_stats[Stats.strength] = 10
