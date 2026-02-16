extends Node2D

var player_starting_health = 25
@onready var player_base_health = player_starting_health
var player_starting_attack = 2
@onready var player_base_attack = player_starting_attack

var enemy_starting_health = 10
@onready var enemy_base_health = enemy_starting_health
var enemy_starting_attack = 4
@onready var enemy_base_attack = enemy_starting_attack

var enemy_growth_health = 10
var enemy_growth_attack = 1


func increase_player_health(delta):
	player_base_health += delta

func increase_player_attack(delta):
	player_base_attack += delta

func increase_enemy_health(delta):
	enemy_base_health += delta

func increase_enemy_attack(delta):
	enemy_base_attack += delta

func get_player_stats() -> Array:
	return [player_base_health, player_base_attack]

func get_enemy_stats() -> Array:
	return [enemy_base_health, enemy_base_attack]


func reset_to_starting_stats():
	player_base_health = player_starting_health
	player_base_attack = player_starting_attack
	enemy_base_health = enemy_starting_health
	enemy_base_attack = enemy_starting_attack


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	HudEvents.ask_for_combatant_base_stats.connect(send_base_stats)
	StatEvents.health_increased.connect(increase_player_health)
	StatEvents.attack_increased.connect(increase_player_attack)
	StatEvents.enemy_stat_scale.connect(grow_enemies)
	HudEvents.combat_lost.connect(reset_to_starting_stats)


func send_base_stats():
	HudEvents.send_combatant_base_stats.emit(get_player_stats(), get_enemy_stats())


func grow_enemies():
	increase_enemy_health(enemy_growth_health)
	increase_enemy_attack(enemy_growth_attack)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
