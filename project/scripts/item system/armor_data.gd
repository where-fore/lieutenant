extends Item
class_name Armor

@export var health:int = 0

func setup_item_stats() -> void:
	my_additive_stat_dictionary[Stats.health] = health
