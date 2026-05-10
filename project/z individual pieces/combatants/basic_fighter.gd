extends Combatant

func _init() -> void:
	combatant_id = "basic_player_fighter" # "generic_enemy"
	combatant_name = "John the Fighter" # "Generic Combatant"
	combatant_texture = load("res://sprites/knight.png")
	extra_tooltip = "" # "Generic flavourful description"
	
	starting_stats[Stats.strength] = 20
	starting_stats[Stats.dexterity] = 5
