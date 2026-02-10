extends Node2D

@export var health = 10 as int
@export var damage = 2 as int

func get_health() -> int:
	return health


func get_damage() -> int:
	return damage
