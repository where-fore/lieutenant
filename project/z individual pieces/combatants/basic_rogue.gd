extends Combatant

func _init() -> void:
	combatant_name = "Shara" # "Generic Combatant"
	combatant_texture = load("res://sprites/portraits/lady_1.png")
	extra_tooltip = "" # "Generic flavourful description"
	
	starting_stats[Stats.strength] = BalanceData.player_base_strength / 2
	starting_stats[Stats.dexterity] = BalanceData.player_base_dexterity * 2

	starting_items = [Database.get_item_by_id("iron_dirk"), Database.get_item_by_id("iron_sword")]
