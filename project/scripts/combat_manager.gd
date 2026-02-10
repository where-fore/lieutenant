extends Node2D

@onready var current_player = $"Player Combatant"
@onready var current_enemy = $"Enemy Combatant"

var player_turn = "Player"
var enemy_turn = "Enemy"
var precombat = "Precombat"
var turn = precombat


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	CombatEvents.attack_launched.connect(handle_attack)
	CombatEvents.turn_finished.connect(pass_turn)
	HudEvents.turn_button_pressed.connect(start_turn)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func handle_attack(attacker, amount):
	if attacker.is_the_player():
		current_enemy.take_damage(amount)
	else:
		current_player.take_damage(amount)


func pass_turn():
	#swap turns
	if turn == player_turn: turn = enemy_turn
	elif turn == enemy_turn: turn = player_turn


func start_turn():
	if turn == precombat:
		turn = player_turn
		current_player.take_turn()
		
	elif turn == player_turn:
		current_player.take_turn()
		
	elif turn == enemy_turn: 
		current_enemy.take_turn()
