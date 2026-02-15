extends Node2D


var player_base_health = 25 as int
var player_base_attack = 2 as int

var enemy_base_health = 10 as int
var enemy_base_attack = 1 as int


func increase_player_health(delta):
	player_base_health += delta

func increase_player_attack(delta):
	player_base_attack += delta

func get_player_stats() -> Array:
	return [player_base_health, player_base_attack]

func get_enemy_stats() -> Array:
	return [enemy_base_health, enemy_base_attack]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	HudEvents.ask_for_combatant_base_stats.connect(send_base_stats)


func send_base_stats():
	HudEvents.send_combatant_base_stats.emit(get_player_stats(), get_enemy_stats())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
