extends Item
class_name Weapon

@export var damage: int = 0

func setup_item_stats() -> void:
	my_additive_stat_dictionary[Stats.attack] = damage
