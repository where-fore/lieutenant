extends Node2D

var player_starting_health = 25
@onready var player_base_health = player_starting_health
var player_starting_attack = 0
@onready var player_base_attack = player_starting_attack

var enemy_starting_health = 10
@onready var enemy_base_health = enemy_starting_health
var enemy_starting_attack = 4
@onready var enemy_base_attack = enemy_starting_attack

var player_attack_bonus: int


func increase_player_health(delta):
	player_base_health += delta

func increase_player_attack(delta):
	player_base_attack += delta

func increase_enemy_health(delta):
	enemy_base_health += delta

func increase_enemy_attack(delta):
	enemy_base_attack += delta

func get_player_stats() -> Array:
	return [player_base_health, player_base_attack + player_attack_bonus]

func get_enemy_stats() -> Array:
	return [enemy_base_health, enemy_base_attack]
	#return [enemy_base_health*(StatEvents.encounters_defeated_for_scaling+1), enemy_base_attack]


func reset_to_starting_stats():
	player_base_health = player_starting_health
	player_base_attack = player_starting_attack
	enemy_base_health = enemy_starting_health
	enemy_base_attack = enemy_starting_attack
	
	StatEvents.encounters_defeated_for_scaling = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	HudEvents.ask_for_combatant_base_stats.connect(send_base_stats)
	HudEvents.combat_won.connect(grow_enemies)
	StatEvents.health_increased.connect(increase_player_health)
	StatEvents.attack_increased.connect(increase_player_attack)
	HudEvents.combat_lost.connect(reset_to_starting_stats)
	InventoryEvents.item_successfully_equipped.connect(interpret_new_item)
	InventoryEvents.item_successfully_unequipped.connect(interpret_removed_item)


func interpret_new_item(item:ItemData):
	if item.damage: player_attack_bonus += item.damage
	send_base_stats()

func interpret_removed_item(item:ItemData):
	if item.damage: player_attack_bonus -= item.damage
	send_base_stats()

func send_base_stats():
	HudEvents.send_combatant_base_stats.emit(get_player_stats(), get_enemy_stats())

func grow_enemies():
	StatEvents.encounters_defeated_for_scaling += 1
