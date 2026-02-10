extends Node2D

@export var health = 10 as int
func get_health() -> int: return health

@export var attack = 2 as int
func get_attack() -> int: return attack

@export var is_the_player = false as bool

func deal_damage(value):
	health -= value
	
	if is_the_player: HudEvents.player_damaged.emit()
	else: HudEvents.enemy_damaged.emit()
